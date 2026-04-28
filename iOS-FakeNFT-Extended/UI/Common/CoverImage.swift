//
//  CoverImage.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 28.04.2026.
//

import SwiftUI

struct CoverImage: View {
    let imageSourceType: ImageSourceType
    
    var body: some View {
        Group {
            switch imageSourceType {
            case .local(let imageResource):
                Image(imageResource)
                    .resizable()
                    .scaledToFill()
            case .remote(let url):
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Rectangle()
                        .fill(Color(.dayNightLightGray))
                        .overlay {
                            ProgressView()
                        }
                }
            }
        }
    }
}
