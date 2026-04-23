//
//  CatalogCollectionViewData.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 22.04.2026.
//

import Foundation
import SwiftUI

enum ImageSourceType: Hashable {
    case remote(URL)
    case local(ImageResource)
}

struct CatalogCollectionItemViewData: Identifiable, Hashable {
    let id: String
    let title: String
    let coverImageType: ImageSourceType
    let nftCount: Int
}
