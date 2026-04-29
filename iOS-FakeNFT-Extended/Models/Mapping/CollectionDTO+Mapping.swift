//
//  CollectionDTO+Mapping.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 28.04.2026.
//

import Foundation

extension CollectionDTO {
    func toDomain() -> Collection {
        Collection(
            id: id,
            name: name,
            cover: cover,
            nfts: nfts,
            author: author,
            description: description,
            websiteURL: website.flatMap(URL.init(string:)),
            createdAt: createdAt
        )
    }
}
