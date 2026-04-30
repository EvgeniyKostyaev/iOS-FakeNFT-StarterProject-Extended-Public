//
//  Collection.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 28.04.2026.
//

import Foundation

struct Collection: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let cover: URL
    let nfts: [String]
    let author: String
    let description: String
    let websiteURL: URL?
    let createdAt: String?
}
