//
//  CollectionViewData.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 27.04.2026.
//

import Foundation

struct CollectionViewData: Identifiable, Hashable {
    let id: String
    let title: String
    let coverImageType: ImageSourceType
    let nftCount: Int
}
