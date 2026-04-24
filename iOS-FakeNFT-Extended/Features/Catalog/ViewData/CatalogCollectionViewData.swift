//
//  CatalogCollectionViewData.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 22.04.2026.
//

import Foundation
import SwiftUI

enum ImageSourceType: Hashable {
    case remote(URL)
    case local(ImageResource)
}

struct CollectionViewData: Identifiable, Hashable {
    let id: String
    let title: String
    let coverImageType: ImageSourceType
    let nftCount: Int
}

struct CollectionDetailViewData: Identifiable, Hashable {
    let id: String
    let title: String
    let coverImageType: ImageSourceType
    let authorName: String
    let authorURL: URL?
    let description: String
    let nftItems: [CollectionNFTViewData]
}

struct CollectionNFTViewData: Identifiable, Hashable {
    let id: String
    let title: String
    let imageType: ImageSourceType
    let rating: Int
    let price: Decimal
    let isFavorite: Bool
    let isInCart: Bool
}

extension CollectionViewData {
    static func mock() -> [CollectionViewData] {
        [
            CollectionViewData(
                id: "1",
                title: "Peach",
                coverImageType: .local(.collectionPeach),
                nftCount: 11
            ),
            CollectionViewData(
                id: "2",
                title: "Brawn",
                coverImageType: .local(.collectionBrawn),
                nftCount: 8
            ),
            CollectionViewData(
                id: "3",
                title: "White",
                coverImageType: .local(.collectionWhite),
                nftCount: 7
            )
        ]
    }
}

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

private extension CollectionNFTViewData {
    static func mockItems() -> [CollectionNFTViewData] {
        firstRow + secondRow + thirdRow + fourthRow
    }
    
    static var firstRow: [CollectionNFTViewData] {
        [
            CollectionNFTViewData(
                id: "1",
                title: "Archie",
                imageType: .local(._1),
                rating: 2,
                price: 1,
                isFavorite: true,
                isInCart: true
            ),
            CollectionNFTViewData(
                id: "2",
                title: "Ruby",
                imageType: .local(._2),
                rating: 2,
                price: 1,
                isFavorite: true,
                isInCart: false
            ),
            CollectionNFTViewData(
                id: "3",
                title: "Nacho",
                imageType: .local(._3),
                rating: 2,
                price: 1,
                isFavorite: true,
                isInCart: true
            )
        ]
    }
    
    static var secondRow: [CollectionNFTViewData] {
        [
            CollectionNFTViewData(
                id: "4",
                title: "Biscuit",
                imageType: .local(._4),
                rating: 2,
                price: 1,
                isFavorite: false,
                isInCart: false
            ),
            CollectionNFTViewData(
                id: "5",
                title: "Daisy",
                imageType: .local(._5),
                rating: 2,
                price: 1,
                isFavorite: true,
                isInCart: false
            ),
            CollectionNFTViewData(
                id: "6",
                title: "Susan",
                imageType: .local(._6),
                rating: 2,
                price: 1,
                isFavorite: false,
                isInCart: false
            )
        ]
    }
    
    static var thirdRow: [CollectionNFTViewData] {
        [
            CollectionNFTViewData(
                id: "7",
                title: "Oreo",
                imageType: .local(._7),
                rating: 2,
                price: 1,
                isFavorite: true,
                isInCart: false
            ),
            CollectionNFTViewData(
                id: "8",
                title: "Pixi",
                imageType: .local(._8),
                rating: 2,
                price: 1,
                isFavorite: true,
                isInCart: false
            ),
            CollectionNFTViewData(
                id: "9",
                title: "Zoe",
                imageType: .local(._9),
                rating: 2,
                price: 1,
                isFavorite: false,
                isInCart: false
            )
        ]
    }
    
    static var fourthRow: [CollectionNFTViewData] {
        [
            CollectionNFTViewData(
                id: "10",
                title: "Tater",
                imageType: .local(._10),
                rating: 2,
                price: 1,
                isFavorite: true,
                isInCart: false
            )
        ]
    }
}
