//
//  CatalogSortingStorage.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 30.04.2026.
//

import Foundation

protocol CatalogSortingStorage {
    func loadSorting() -> CatalogSorting
    func saveSorting(_ sorting: CatalogSorting)
}

struct CatalogSortingStorageImpl: CatalogSortingStorage {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func loadSorting() -> CatalogSorting {
        guard let rawValue = userDefaults.string(forKey: CatalogSorting.storageKey),
              let sorting = CatalogSorting(rawValue: rawValue) else {
            return .byNftCount
        }

        return sorting
    }

    func saveSorting(_ sorting: CatalogSorting) {
        userDefaults.set(sorting.rawValue, forKey: CatalogSorting.storageKey)
    }
}
