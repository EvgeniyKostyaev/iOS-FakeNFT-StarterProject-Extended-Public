//
//  CatalogViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 23.04.2026.
//

import Foundation

@Observable
final class CatalogViewModel {
    var items: [CatalogCollectionItemViewData] = []
    
    init() {
        loadMock()
    }
    
    private func loadMock() {
        items = [
            CatalogCollectionItemViewData(
                id: "1",
                title: "Peach",
                coverImageType: .local(.collectionPeach),
                subtitle: "(11)"
            ),
            CatalogCollectionItemViewData(
                id: "2",
                title: "Brawn",
                coverImageType: .local(.collectionBrawn),
                subtitle: "(8)"
            ),
            CatalogCollectionItemViewData(
                id: "3",
                title: "White",
                coverImageType: .local(.collectionWhite),
                subtitle: "(7)"
            )
        ]
    }
}
