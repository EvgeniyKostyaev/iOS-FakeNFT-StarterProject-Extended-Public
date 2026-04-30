//
//  CollectionDetailViewData.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 27.04.2026.
//

import Foundation

struct CollectionDetailViewData: Identifiable, Hashable {
    let id: String
    let title: String
    let coverImageType: ImageSourceType
    let authorName: String
    let authorURL: URL?
    let description: String
    let nftItems: [CollectionNFTViewData]
}
