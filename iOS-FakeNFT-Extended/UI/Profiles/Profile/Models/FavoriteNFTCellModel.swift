//
//  FavoriteNFTCellModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 23.04.2026.
//

import Foundation

struct FavoriteNFTCellModel: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let rating: Int
    let price: Double
    let previewImageURL: URL?

    init(nft: Nft) {
        id = nft.id
        name = nft.name
        rating = nft.rating
        price = nft.price
        previewImageURL = nft.previewImageURL
    }
}
