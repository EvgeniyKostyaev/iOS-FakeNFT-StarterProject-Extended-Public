//
//  CollectionDetailViewData+Mock.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 27.04.2026.
//

import Foundation

extension CollectionDetailViewData {
    static func mock(from collection: CollectionViewData) -> CollectionDetailViewData {
        CollectionDetailViewData(
            id: collection.id,
            title: collection.title,
            coverImageType: collection.coverImageType,
            authorName: "John Doe",
            authorURL: URL(string: "https://practicum.yandex.ru/ios-developer/?from=catalog"),
            description: "Персиковый - как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей.",
            nftItems: CollectionNFTViewData.mockItems()
        )
    }
}
