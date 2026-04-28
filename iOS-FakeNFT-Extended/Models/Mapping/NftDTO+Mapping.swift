//
//  NftDTO+Mapping.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 28.04.2026.
//

import Foundation

extension NftDTO {
    func toDomain() -> Nft {
        Nft(
            id: id,
            name: name,
            images: images,
            rating: rating,
            description: description,
            price: price,
            author: author,
            websiteURL: website.flatMap(URL.init(string:)),
            createdAt: createdAt
        )
    }
}
