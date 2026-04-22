//
//  CatalogCollectionViewData.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 22.04.2026.
//

import Foundation

struct CatalogCollectionItemViewData: Identifiable {
    let id: String
    let title: String
    let images: [URL]
    let subtitle: String
}
