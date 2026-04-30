//
//  MyNFTListRowModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 23.04.2026.
//

import Foundation

struct MyNFTListRowModel: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let author: String
    let rating: Int
    let price: Double
    let previewImageURL: URL?
    let isLiked: Bool

    init(nft: NftDTO, likedNFTIds: Set<String>) {
        id = nft.id
        name = nft.name
        author = nft.author
        rating = nft.rating
        price = nft.price
        previewImageURL = nft.previewImageURL
        isLiked = likedNFTIds.contains(nft.id)
    }
}
