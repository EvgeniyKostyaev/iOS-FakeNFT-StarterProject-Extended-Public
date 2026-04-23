//
//  FavoriteNFTViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 06.04.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class FavoriteNFTViewModel {

    enum Phase: Equatable {
        case idle
        case loading
        case ready([Nft])
        case failed(String)
    }

    private(set) var phase: Phase = .idle
    private(set) var removeFavoriteError: String?

    var cellModels: [FavoriteNFTCellModel] {
        guard case .ready(let nfts) = phase else { return [] }
        return nfts.map { FavoriteNFTCellModel(nft: $0) }
    }

    func load(likedNFTIds: [String], nftService: NftService) async {
        guard !likedNFTIds.isEmpty else {
            phase = .ready([])
            return
        }

        phase = .loading

        var ordered: [Nft] = []
        ordered.reserveCapacity(likedNFTIds.count)

        for id in likedNFTIds {
            do {
                let nft = try await nftService.loadNft(id: id)
                ordered.append(nft)
            } catch {
                phase = .failed(NSLocalizedString("FavoriteNFT.loadFailed", comment: ""))
                return
            }
        }

        phase = .ready(ordered)
    }

    func clearRemoveFavoriteError() {
        removeFavoriteError = nil
    }

    func removeFromFavorites(
        nftId: String,
        profile: ProfileScreen,
        profileService: ProfileServiceProtocol
    ) async {
        removeFavoriteError = nil

        guard case .ready(let nfts) = phase else { return }
        guard profile.likes.contains(nftId) else { return }

        let newLikes = profile.likes.filter { $0 != nftId }
        let payload = ProfileUpdatePayload(
            name: profile.name,
            description: profile.description,
            website: profile.websiteURL.absoluteString,
            avatar: profile.avatarURL?.absoluteString ?? "",
            likes: newLikes,
            nfts: profile.nfts
        )

        do {
            try await profileService.updateProfile(payload)
            let filtered = nfts.filter { $0.id != nftId }
            phase = .ready(filtered)
            NotificationCenter.default.post(name: .profileDidUpdate, object: nil)
        } catch {
            removeFavoriteError = NSLocalizedString("FavoriteNFT.removeFailed", comment: "")
        }
    }
}
