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
    private(set) var actionErrorMessage: String?
    private var isUpdatingFavorite = false
    private var isUpdatingCart = false

    var nfts: [CollectionNFTViewData] {
        guard case .ready(let nfts) = state else { return [] }
        return nfts
    }

    init(collection: Collection) {
        self.collection = collection
    }

    func clearActionError() {
        actionErrorMessage = nil
    }

    func loadNFTsIfNeeded(
        collectionDetailsService: CollectionDetailsService
    ) async {
        if case .ready = state, !nfts.isEmpty { return }

        await reloadNFTs(collectionDetailsService: collectionDetailsService)
    }

    func reloadNFTs(
        collectionDetailsService: CollectionDetailsService
    ) async {
        if case .loading = state { return }
        state = .loading
        do {
            state = .ready(
                try await collectionDetailsService.loadNFTs(for: collection)
            )
        } catch {
            state = .failed(
                message: NSLocalizedString("CollectionDetail.loadFailed", comment: "")
            )
        }
    }

    func toggleCart(
        nftId: String,
        collectionDetailsService: CollectionDetailsService
    ) async {
        actionErrorMessage = nil

        guard case .ready(let currentNFTs) = state,
              !isUpdatingCart else { return }

        isUpdatingCart = true
        defer { isUpdatingCart = false }

        do {
            try await collectionDetailsService.updateCartStatus(for: nftId)
            state = .ready(toggleCartState(for: nftId, in: currentNFTs))
        } catch {
            actionErrorMessage = NSLocalizedString("CollectionDetail.cartUpdateFailed", comment: "")
        }
    }

    func toggleFavorite(
        nftId: String,
        collectionDetailsService: CollectionDetailsService
    ) async {
        actionErrorMessage = nil

        guard case .ready(let currentNFTs) = state,
              !isUpdatingFavorite else { return }

        isUpdatingFavorite = true
        defer { isUpdatingFavorite = false }

        do {
            try await collectionDetailsService.updateFavoriteStatus(for: nftId)
            state = .ready(toggleFavoriteState(for: nftId, in: currentNFTs))
        } catch {
            actionErrorMessage = NSLocalizedString("CollectionDetail.favoriteUpdateFailed", comment: "")
        }
    }

    private func toggleFavoriteState(
        for nftId: String,
        in items: [CollectionNFTViewData]
    ) -> [CollectionNFTViewData] {
        items.map { item in
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
    }

    private func toggleCartState(
        for nftId: String,
        in items: [CollectionNFTViewData]
    ) -> [CollectionNFTViewData] {
        items.map { item in
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
    }
}
