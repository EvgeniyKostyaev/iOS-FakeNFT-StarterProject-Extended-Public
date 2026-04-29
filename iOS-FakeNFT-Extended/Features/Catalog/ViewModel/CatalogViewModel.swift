//
//  CatalogViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 23.04.2026.
//

import Foundation

private enum CatalogSorting: String {
    case byName
    case byNftCount

    private static let storageKey = "catalog.sorting"

    static func loadSaved() -> CatalogSorting {
        guard let rawValue = UserDefaults.standard.string(forKey: storageKey),
              let sorting = CatalogSorting(rawValue: rawValue) else {
            return .byNftCount
        }

        return sorting
    }

    func save() {
        UserDefaults.standard.set(rawValue, forKey: Self.storageKey)
    }
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
    private var currentSorting: CatalogSorting

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

    init() {
        currentSorting = CatalogSorting.loadSaved()
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
        currentSorting.save()
        applyCurrentSorting()
    }
    
    func sortByCountNFT() {
        currentSorting = .byNftCount
        currentSorting.save()
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
