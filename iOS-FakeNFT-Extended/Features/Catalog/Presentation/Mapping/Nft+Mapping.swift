//
//  Nft+Mapping.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 28.04.2026.
//

import Foundation

extension Nft {
    func toViewData(
        id: String? = nil,
        isFavorite: Bool = false,
        isInCart: Bool = false
    ) -> CollectionNFTViewData {
        CollectionNFTViewData(
            id: id ?? self.id,
            nftId: self.id,
            title: name,
            imageType: previewImageURL.map(ImageSourceType.remote) ?? .local(._1),
            rating: rating,
            price: Decimal(price),
            isFavorite: isFavorite,
            isInCart: isInCart
        )
    }
}
