//
//  Collection+Mapping.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 28.04.2026.
//

import Foundation

extension Collection {
    func toViewData() -> CollectionViewData {
        CollectionViewData(
            id: id,
            title: name,
            coverImageType: .remote(cover),
            nftCount: nfts.count
        )
    }
}
