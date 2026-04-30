//
//  CatalogSorting.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 30.04.2026.
//

import Foundation

enum CatalogSorting: String {
    case byName
    case byNftCount

    static let storageKey = "catalog.sorting"
}
