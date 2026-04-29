//
//  CollectionDetailsViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 28.04.2026.
//

import Foundation

@MainActor
@Observable
final class CollectionDetailsViewModel {
    enum State: Equatable {
        case idle
        case loading
        case ready([CollectionNFTViewData])
        case failed(message: String)
    }

    let collection: Collection
 
    private(set) var state: State = .idle

    var nfts: [CollectionNFTViewData] {
        guard case .ready(let nfts) = state else { return [] }
        return nfts
    }

    init(collection: Collection) {
        self.collection = collection
    }

    func loadNFTsIfNeeded(nftService: NftService) async {
        if case .ready = state, !nfts.isEmpty { return }

        await reloadNFTs(nftService: nftService)
    }

    func reloadNFTs(nftService: NftService) async {
        if case .loading = state { return }

        state = .loading

        let nftItems = await loadNftItems(nftService: nftService)

        guard !nftItems.isEmpty else {
            state = .failed(
                message: NSLocalizedString("CollectionDetail.loadFailed", comment: "")
            )
            return
        }

        state = .ready(nftItems.map { index, nft in
            nft.toViewData(id: "\(nft.id)-\(index)")
        })
    }

    private func loadNftItems(nftService: NftService) async -> [(Int, Nft)] {
        await withTaskGroup(of: (Int, Nft?).self, returning: [(Int, Nft)].self) { group in
            for (index, nftId) in collection.nfts.enumerated() {
                group.addTask {
                    do {
                        let nftDTO = try await nftService.loadNft(id: nftId)
                        return (index, nftDTO.toDomain())
                    } catch {
                        return (index, nil)
                    }
                }
            }

            var indexedNfts: [(Int, Nft)] = []
            indexedNfts.reserveCapacity(collection.nfts.count)

            for await (index, nft) in group {
                guard let nft else { continue }
                indexedNfts.append((index, nft))
            }

            return indexedNfts
                .sorted { $0.0 < $1.0 }
        }
    }
}
