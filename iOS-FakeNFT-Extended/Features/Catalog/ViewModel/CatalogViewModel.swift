//
//  CatalogViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 23.04.2026.
//

import Foundation

@Observable
final class CatalogViewModel {
    private(set) var items: [CatalogCollectionItemViewData] = []
    private(set) var isLoading: Bool = false
    
    init() {
        loadMock()
    }
    
    func sortByName() {
        items.sort { $0.title < $1.title }
    }
    
    func sortByCountNFT() {
        items.sort { $0.nftCount > $1.nftCount }
    }
    
    private func loadMock() {
        items = [
            CatalogCollectionItemViewData(
                id: "1",
                title: "Peach",
                coverImageType: .local(.collectionPeach),
                nftCount: 11
            ),
            CatalogCollectionItemViewData(
                id: "2",
                title: "Brawn",
                coverImageType: .local(.collectionBrawn),
                nftCount: 8
            ),
            CatalogCollectionItemViewData(
                id: "3",
                title: "White",
                coverImageType: .local(.collectionWhite),
                nftCount: 7
            )
        ]
    }
}
