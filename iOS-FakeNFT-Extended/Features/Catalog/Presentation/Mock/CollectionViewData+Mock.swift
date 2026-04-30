//
//  CollectionViewData+Mock.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 27.04.2026.
//

import Foundation

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
