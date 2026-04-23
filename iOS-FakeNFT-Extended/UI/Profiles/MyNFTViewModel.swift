//
//  MyNFTViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 23.04.2026.
//

import Foundation
import Observation

enum MyNFTSortCriterion: String, CaseIterable, Sendable {
    case price
    case rating
    case name

    private static let storageKey = "myNFT.sortCriterion"

    static func loadSaved() -> MyNFTSortCriterion {
        guard let raw = UserDefaults.standard.string(forKey: storageKey),
              let value = MyNFTSortCriterion(rawValue: raw)
        else {
            return .rating
        }
        return value
    }

    func save() {
        UserDefaults.standard.set(rawValue, forKey: Self.storageKey)
    }

    static func sorted(_ nfts: [Nft], by criterion: MyNFTSortCriterion) -> [Nft] {
        switch criterion {
        case .name:
            return nfts.sorted {
                let order = $0.name.localizedCaseInsensitiveCompare($1.name)
                switch order {
                case .orderedAscending: return true
                case .orderedDescending: return false
                case .orderedSame: return $0.id < $1.id
                @unknown default: return $0.id < $1.id
                }
            }
        case .price:
            return nfts.sorted {
                if $0.price != $1.price { return $0.price < $1.price }
                return $0.id < $1.id
            }
        case .rating:
            return nfts.sorted {
                if $0.rating != $1.rating { return $0.rating > $1.rating }
                let nameOrder = $0.name.localizedCaseInsensitiveCompare($1.name)
                switch nameOrder {
                case .orderedAscending: return true
                case .orderedDescending: return false
                case .orderedSame: return $0.id < $1.id
                @unknown default: return $0.id < $1.id
                }
            }
        }
    }
}

@MainActor
@Observable
final class MyNFTViewModel {

    enum Phase: Equatable {
        case idle
        case loading
        case ready([Nft])
        case failed(String)
    }

    private(set) var phase: Phase = .idle
    private(set) var sortCriterion: MyNFTSortCriterion

    init() {
        sortCriterion = MyNFTSortCriterion.loadSaved()
    }

    func load(nftIds: [String], nftService: NftService) async {
        guard !nftIds.isEmpty else {
            phase = .ready([])
            return
        }

        phase = .loading

        var ordered: [Nft] = []
        ordered.reserveCapacity(nftIds.count)

        for id in nftIds {
            do {
                let nft = try await nftService.loadNft(id: id)
                ordered.append(nft)
            } catch {
                phase = .failed(NSLocalizedString("MyNFT.loadFailed", comment: ""))
                return
            }
        }

        phase = .ready(MyNFTSortCriterion.sorted(ordered, by: sortCriterion))
    }

    func setSortCriterion(_ criterion: MyNFTSortCriterion) {
        guard sortCriterion != criterion else { return }
        sortCriterion = criterion
        criterion.save()
        guard case .ready(let nfts) = phase else { return }
        phase = .ready(MyNFTSortCriterion.sorted(nfts, by: criterion))
    }
}
