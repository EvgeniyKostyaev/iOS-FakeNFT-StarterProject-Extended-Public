//
//  CollectionNFTViewData+Mock.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 27.04.2026.
//

import Foundation

extension CollectionNFTViewData {
    static func mockItems() -> [CollectionNFTViewData] {
        firstRow + secondRow + thirdRow + fourthRow
    }
    
    static var firstRow: [CollectionNFTViewData] {
        [
            CollectionNFTViewData(
                id: "1",
                nftId: "1",
                title: "Archie",
                imageType: .local(._1),
                rating: 2,
                price: 1,
                isFavorite: true,
                isInCart: true
            ),
            CollectionNFTViewData(
                id: "2",
                nftId: "2",
                title: "Ruby",
                imageType: .local(._2),
                rating: 2,
                price: 1,
                isFavorite: true,
                isInCart: false
            ),
            CollectionNFTViewData(
                id: "3",
                nftId: "3",
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
                nftId: "4",
                title: "Biscuit",
                imageType: .local(._4),
                rating: 2,
                price: 1,
                isFavorite: false,
                isInCart: false
            ),
            CollectionNFTViewData(
                id: "5",
                nftId: "5",
                title: "Daisy",
                imageType: .local(._5),
                rating: 2,
                price: 1,
                isFavorite: true,
                isInCart: false
            ),
            CollectionNFTViewData(
                id: "6",
                nftId: "6",
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
                nftId: "7",
                title: "Oreo",
                imageType: .local(._7),
                rating: 2,
                price: 1,
                isFavorite: true,
                isInCart: false
            ),
            CollectionNFTViewData(
                id: "8",
                nftId: "8",
                title: "Pixi",
                imageType: .local(._8),
                rating: 2,
                price: 1,
                isFavorite: true,
                isInCart: false
            ),
            CollectionNFTViewData(
                id: "9",
                nftId: "9",
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
                nftId: "10",
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
