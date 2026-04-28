//
//  CollectionDTO.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 28.04.2026.
//

import Foundation

struct CollectionDTO: Decodable, Sendable, Identifiable, Hashable {
    let id: String
    let website: String?
    let author: String
    let description: String
    let nfts: [String]
    let cover: URL
    let name: String
    let createdAt: String?
}

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
