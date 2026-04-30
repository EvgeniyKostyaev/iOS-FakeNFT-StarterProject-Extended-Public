//
//  CollectionDetailsService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 30.04.2026.
//

import Foundation

protocol CollectionDetailsService {
    func loadNFTs(for collection: Collection) async throws -> [CollectionNFTViewData]
    func updateFavoriteStatus(for nftId: String) async throws
    func updateCartStatus(for nftId: String) async throws
}

final class CollectionDetailsServiceImpl: CollectionDetailsService {
    private let nftService: NftService
    private let profileService: ProfileServiceProtocol
    private let orderService: OrderService

    init(
        nftService: NftService,
        profileService: ProfileServiceProtocol,
        orderService: OrderService
    ) {
        self.nftService = nftService
        self.profileService = profileService
        self.orderService = orderService
    }

    func loadNFTs(for collection: Collection) async throws -> [CollectionNFTViewData] {
        async let nftItemsTask = loadNftItems(for: collection)
        async let likedNFTIdsTask = loadLikedNFTIds()
        async let cartNFTIdsTask = loadCartNFTIds()

        let nftItems = await nftItemsTask
        let likedNFTIds = try await likedNFTIdsTask
        let cartNFTIds = try await cartNFTIdsTask

        return nftItems.map { index, nft in
            nft.toViewData(
                id: "\(nft.id)-\(index)",
                isFavorite: likedNFTIds.contains(nft.id),
                isInCart: cartNFTIds.contains(nft.id)
            )
        }
    }

    func updateFavoriteStatus(for nftId: String) async throws {
        let profile = try await profileService.loadProfile(
            userId: ProfileAPIPath.gatewayProfilePathSegment
        )

        let payload = ProfileUpdatePayload(
            name: profile.name,
            description: profile.description,
            website: profile.websiteURL.absoluteString,
            avatar: profile.avatarURL?.absoluteString ?? "",
            likes: makeUpdatedLikes(currentLikes: profile.likes, nftId: nftId),
            nfts: profile.nfts
        )

        try await profileService.updateProfile(payload)
        NotificationCenter.default.post(name: .profileDidUpdate, object: nil)
    }

    func updateCartStatus(for nftId: String) async throws {
        let order = try await orderService.loadOrder(id: OrderAPIPath.gatewayOrderPathSegment)
        let payload = OrderUpdatePayload(
            nfts: makeUpdatedCartNFTs(currentNFTIds: order.nfts, nftId: nftId)
        )

        _ = try await orderService.updateOrder(
            id: OrderAPIPath.gatewayOrderPathSegment,
            payload: payload
        )
    }

    private func loadNftItems(for collection: Collection) async -> [(Int, Nft)] {
        await withTaskGroup(of: (Int, Nft?).self, returning: [(Int, Nft)].self) { group in
            for (index, nftId) in collection.nfts.enumerated() {
                group.addTask {
                    do {
                        let nftDTO = try await self.nftService.loadNft(id: nftId)
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

            return indexedNfts.sorted { $0.0 < $1.0 }
        }
    }

    private func loadLikedNFTIds() async throws -> Set<String> {
        let profile = try await profileService.loadProfile(
            userId: ProfileAPIPath.gatewayProfilePathSegment
        )

        return Set(profile.likes)
    }

    private func loadCartNFTIds() async throws -> Set<String> {
        let order = try await orderService.loadOrder(
            id: OrderAPIPath.gatewayOrderPathSegment
        )

        return Set(order.nfts)
    }

    private func makeUpdatedLikes(
        currentLikes: [String],
        nftId: String
    ) -> [String] {
        if currentLikes.contains(nftId) {
            return currentLikes.filter { $0 != nftId }
        }

        return currentLikes + [nftId]
    }

    private func makeUpdatedCartNFTs(
        currentNFTIds: [String],
        nftId: String
    ) -> [String] {
        if currentNFTIds.contains(nftId) {
            return currentNFTIds.filter { $0 != nftId }
        }

        return currentNFTIds + [nftId]
    }
}
