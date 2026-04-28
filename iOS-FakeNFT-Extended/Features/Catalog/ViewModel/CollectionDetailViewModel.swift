//
//  CollectionDetailViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 28.04.2026.
//

import Foundation

@MainActor
@Observable
final class CollectionDetailViewModel {
    let collection: Collection

    private(set) var nfts: [CollectionNFTViewData] = []
    private(set) var isLoading: Bool = false

    init(collection: Collection) {
        self.collection = collection
    }

    func loadNFTs(nftService: NftService) async {
        guard !isLoading else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let nftItems = try await loadNftItems(nftService: nftService)
            nfts = nftItems.map { index, nft in
                nft.toViewData(id: "\(nft.id)-\(index)")
            }
        } catch {
            nfts = []
        }
    }

    private func loadNftItems(nftService: NftService) async throws -> [(Int, Nft)] {
        try await withThrowingTaskGroup(of: (Int, Nft).self, returning: [(Int, Nft)].self) { group in
            for (index, nftId) in collection.nfts.enumerated() {
                group.addTask {
                    let nftDTO = try await nftService.loadNft(id: nftId)
                    return (index, nftDTO.toDomain())
                }
            }

            var indexedNfts: [(Int, Nft)] = []
            indexedNfts.reserveCapacity(collection.nfts.count)

            for try await item in group {
                indexedNfts.append(item)
            }

            return indexedNfts
                .sorted { $0.0 < $1.0 }
        }
    }
}
