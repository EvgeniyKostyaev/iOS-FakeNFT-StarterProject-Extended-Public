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
    private var sourceCollections: [Collection] = []
    private var currentSorting: CatalogSorting = .byNftCount
    
    private(set) var collections: [CollectionViewData] = []
    private(set) var isLoading: Bool = false
    
    func loadCollections(catalogService: CatalogService) async {
        guard !isLoading else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            sourceCollections = try await catalogService.loadCollections()
                .map { $0.toDomain() }

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

    func collection(id: String) -> Collection? {
        sourceCollections.first { $0.id == id }
    }
    
    private func applyCurrentSorting() {
        switch currentSorting {
        case .byName:
            collections = sourceCollections.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
            .map { $0.toViewData() }
        case .byNftCount:
            collections = sourceCollections.sorted {
                if $0.nfts.count == $1.nfts.count {
                    return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
                }
                
                return $0.nfts.count > $1.nfts.count
            }
            .map { $0.toViewData() }
        }
    }
}
