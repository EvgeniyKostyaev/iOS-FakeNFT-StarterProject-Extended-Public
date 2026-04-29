//
//  CatalogViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 23.04.2026.
//

import Foundation

private enum CatalogSorting {
    case byName
    case byNftCount
}

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
    private var currentSorting: CatalogSorting = .byNftCount

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
        applyCurrentSorting()
    }
    
    func sortByCountNFT() {
        currentSorting = .byNftCount
        applyCurrentSorting()
    }

    private func applyCurrentSorting() {
        switch currentSorting {
        case .byName:
            state = .ready(sourceCollections.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            })
        case .byNftCount:
            state = .ready(sourceCollections.sorted {
                if $0.nfts.count == $1.nfts.count {
                    return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
                }
                
                return $0.nfts.count > $1.nfts.count
            })
        }
    }
}
