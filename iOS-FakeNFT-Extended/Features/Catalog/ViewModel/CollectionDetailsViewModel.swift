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

    func loadNFTs(nftService: NftService, profileService: ProfileServiceProtocol) async {
        if case .loading = state { return }
        if case .ready = state, !nfts.isEmpty { return }

        state = .loading

        do {
            async let nftItemsTask = loadNftItems(nftService: nftService)
            async let likedNFTIdsTask = loadLikedNFTIds(profileService: profileService)

            let nftItems = try await nftItemsTask
            let likedNFTIds = try await likedNFTIdsTask

            state = .ready(nftItems.map { index, nft in
                nft.toViewData(
                    id: "\(nft.id)-\(index)",
                    isFavorite: likedNFTIds.contains(nft.id)
                )
            })
        } catch {
            state = .failed(
                message: NSLocalizedString("CollectionDetail.loadFailed", comment: "")
            )
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

    private func loadLikedNFTIds(profileService: ProfileServiceProtocol) async throws -> Set<String> {
        let profile = try await profileService.loadProfile(
            userId: ProfileAPIPath.gatewayProfilePathSegment
        )

        return Set(profile.likes)
    }
}
