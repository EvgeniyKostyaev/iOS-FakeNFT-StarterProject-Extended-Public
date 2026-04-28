//
//  Nft+Mapping.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 28.04.2026.
//

import Foundation

extension Nft {
    func toViewData() -> CollectionNFTViewData {
        CollectionNFTViewData(
            id: id,
            title: name,
            imageType: previewImageURL.map(ImageSourceType.remote) ?? .local(._1),
            rating: rating,
            price: Decimal(price),
            isFavorite: false,
            isInCart: false
        )
    }
}
