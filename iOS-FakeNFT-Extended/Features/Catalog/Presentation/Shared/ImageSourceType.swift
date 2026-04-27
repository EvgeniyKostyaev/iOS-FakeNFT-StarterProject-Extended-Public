//
//  ImageSourceType.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 27.04.2026.
//

import SwiftUI

enum ImageSourceType: Hashable {
    case remote(URL)
    case local(ImageResource)
}
