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
    private var isUpdatingFavorite = false
    private var isUpdatingCart = false

    var nfts: [CollectionNFTViewData] {
        guard case .ready(let nfts) = state else { return [] }
        return nfts
    }

    init(collection: Collection) {
        self.collection = collection
    }

    func loadNFTs(
        nftService: NftService,
        profileService: ProfileServiceProtocol,
        orderService: OrderService
    ) async {
        if case .loading = state { return }
        if case .ready = state, !nfts.isEmpty { return }

        state = .loading

        do {
            async let nftItemsTask = loadNftItems(nftService: nftService)
            async let likedNFTIdsTask = loadLikedNFTIds(profileService: profileService)
            async let cartNFTIdsTask = loadCartNFTIds(orderService: orderService)

            let nftItems = try await nftItemsTask
            let likedNFTIds = try await likedNFTIdsTask
            let cartNFTIds = try await cartNFTIdsTask

            state = .ready(nftItems.map { index, nft in
                nft.toViewData(
                    id: "\(nft.id)-\(index)",
                    isFavorite: likedNFTIds.contains(nft.id),
                    isInCart: cartNFTIds.contains(nft.id)
                )
            })
        } catch {
            state = .failed(
                message: NSLocalizedString("CollectionDetail.loadFailed", comment: "")
            )
        }
    }

    func toggleCart(
        nftId: String,
        orderService: OrderService
    ) async {
        guard case .ready(let currentNFTs) = state,
              !isUpdatingCart else { return }

        isUpdatingCart = true
        defer { isUpdatingCart = false }

        do {
            let order = try await orderService.loadOrder(id: OrderAPIPath.gatewayOrderPathSegment)
            let updatedNfts = makeUpdatedCartNFTs(currentNFTIds: order.nfts, nftId: nftId)
            let payload = OrderUpdatePayload(nfts: updatedNfts)

            _ = try await orderService.updateOrder(
                id: OrderAPIPath.gatewayOrderPathSegment,
                payload: payload
            )

            state = .ready(
                currentNFTs.map { item in
                    guard item.nftId == nftId else { return item }

                    return CollectionNFTViewData(
                        id: item.id,
                        nftId: item.nftId,
                        title: item.title,
                        imageType: item.imageType,
                        rating: item.rating,
                        price: item.price,
                        isFavorite: item.isFavorite,
                        isInCart: !item.isInCart
                    )
                }
            )
        } catch {
            state = .failed(
                message: NSLocalizedString("CollectionDetail.loadFailed", comment: "")
            )
        }
    }

    func toggleFavorite(
        nftId: String,
        profileService: ProfileServiceProtocol
    ) async {
        guard case .ready(let currentNFTs) = state,
              !isUpdatingFavorite else { return }

        isUpdatingFavorite = true
        defer { isUpdatingFavorite = false }

        do {
            let profile = try await profileService.loadProfile(
                userId: ProfileAPIPath.gatewayProfilePathSegment
            )

            let updatedLikes = makeUpdatedLikes(
                currentLikes: profile.likes,
                nftId: nftId
            )
            let payload = ProfileUpdatePayload(
                name: profile.name,
                description: profile.description,
                website: profile.websiteURL.absoluteString,
                avatar: profile.avatarURL?.absoluteString ?? "",
                likes: updatedLikes,
                nfts: profile.nfts
            )

            try await profileService.updateProfile(payload)

            state = .ready(
                currentNFTs.map { item in
                    guard item.nftId == nftId else { return item }

                    return CollectionNFTViewData(
                        id: item.id,
                        nftId: item.nftId,
                        title: item.title,
                        imageType: item.imageType,
                        rating: item.rating,
                        price: item.price,
                        isFavorite: !item.isFavorite,
                        isInCart: item.isInCart
                    )
                }
            )

            NotificationCenter.default.post(name: .profileDidUpdate, object: nil)
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

    private func loadCartNFTIds(orderService: OrderService) async throws -> Set<String> {
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
        } else {
            return currentLikes + [nftId]
        }
    }

    private func makeUpdatedCartNFTs(
        currentNFTIds: [String],
        nftId: String
    ) -> [String] {
        if currentNFTIds.contains(nftId) {
            return currentNFTIds.filter { $0 != nftId }
        } else {
            return currentNFTIds + [nftId]
        }
    }
}
