//
//  CollectionNFTViewData.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 27.04.2026.
//

import Foundation

struct CollectionNFTViewData: Identifiable, Hashable {
    let id: String
    let nftId: String
    let title: String
    let imageType: ImageSourceType
    let rating: Int
    let price: Decimal
    let isFavorite: Bool
    let isInCart: Bool
}
