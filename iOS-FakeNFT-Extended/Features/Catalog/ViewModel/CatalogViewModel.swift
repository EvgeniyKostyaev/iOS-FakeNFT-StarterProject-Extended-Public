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
    private var sourceCollections: [CollectionViewData] = []
    private var currentSorting: CatalogSorting = .byName

    private(set) var collections: [CollectionViewData] = []
    private(set) var isLoading: Bool = false

    func loadCollections(catalogService: CatalogService) async {
        guard !isLoading else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let collectionItems = try await catalogService.loadCollections()
                .map { $0.toDomain() }
                .map { $0.toViewData() }

            sourceCollections = collectionItems
            applyCurrentSorting()
        } catch {
            sourceCollections = []
            collections = []
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
            collections = sourceCollections.sorted {
                $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            }
        case .byNftCount:
            collections = sourceCollections.sorted {
                if $0.nftCount == $1.nftCount {
                    return $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
                }

                return $0.nftCount > $1.nftCount
            }
        }
    }
}
