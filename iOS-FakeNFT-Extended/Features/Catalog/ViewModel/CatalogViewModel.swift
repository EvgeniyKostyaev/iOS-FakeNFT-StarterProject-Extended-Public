//
//  CatalogViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 23.04.2026.
//

import Foundation

@MainActor
@Observable
final class CatalogViewModel {
    enum State: Equatable {
        case idle
        case loading
        case ready([Collection])
        case failed(message: String)
    }

    private var sourceCollections: [Collection] = []
    private var currentSorting: CatalogSorting
    private let sortingStorage: CatalogSortingStorage
    private let collectionsSorter: CatalogCollectionsSorter

    private(set) var state: State = .idle

    var collections: [CollectionViewData] {
        guard case .ready(let collections) = state else { return [] }
        return collections.map { $0.toViewData() }
    }

    var isLoading: Bool {
        if case .loading = state {
            return true
        }

        return false
    }

    init(
        sortingStorage: CatalogSortingStorage = CatalogSortingStorageImpl(),
        collectionsSorter: CatalogCollectionsSorter = CatalogCollectionsSorter()
    ) {
        self.sortingStorage = sortingStorage
        self.collectionsSorter = collectionsSorter
        currentSorting = sortingStorage.loadSorting()
    }
    
    func loadCollectionsIfNeeded(catalogService: CatalogService) async {
        if case .ready = state, !sourceCollections.isEmpty { return }

        await reloadCollections(catalogService: catalogService)
    }

    func reloadCollections(catalogService: CatalogService) async {
        if case .loading = state { return }

        state = .loading
        
        do {
            sourceCollections = try await catalogService.loadCollections()
                .map { $0.toDomain() }

            applyCurrentSorting()
        } catch {
            sourceCollections = []
            state = .failed(
                message: NSLocalizedString("Catalog.loadFailed", comment: "")
            )
        }
    }
    
    func sortByName() {
        currentSorting = .byName
        sortingStorage.saveSorting(currentSorting)
        applyCurrentSorting()
    }
    
    func sortByCountNFT() {
        currentSorting = .byNftCount
        sortingStorage.saveSorting(currentSorting)
        applyCurrentSorting()
    }

    private func applyCurrentSorting() {
        state = .ready(
            collectionsSorter.sort(sourceCollections, by: currentSorting)
        )
    }
}
