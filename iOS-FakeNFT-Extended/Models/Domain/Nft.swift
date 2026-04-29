//
//  Nft.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 28.04.2026.
//

import Foundation

struct Nft: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let websiteURL: URL?
    let createdAt: String?

    var previewImageURL: URL? {
        images.first
    }
}
