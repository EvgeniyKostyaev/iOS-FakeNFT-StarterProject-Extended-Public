//
//  CollectionCellView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 21.04.2026.
//

import SwiftUI

private enum CollectionCellViewTheme {
    static let cornerRadius: CGFloat = 12
}

struct CollectionCellView: View {
    let itemViewData: CatalogCollectionItemViewData
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                switch itemViewData.coverImageType {
                case .local(let imageResource):
                    Image(imageResource)
                        .resizable()
                case .remote(let url):
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                    } placeholder: {
                        Image(systemName: "photo.fill")
                            .resizable()
                    }
                }
            }
            .scaledToFill()
            .frame(height: 140, alignment: .top)
            .clipShape(RoundedRectangle(cornerRadius: CollectionCellViewTheme.cornerRadius))
            Text("\(itemViewData.title) \(itemViewData.subtitle)")
                .font(Font.dsBodyBold)
        }
    }
}

#Preview {
    CollectionCellView(
        itemViewData: CatalogCollectionItemViewData(
            id: "1",
            title: "Peach",
            coverImageType: .local(.collectionPeach),
            subtitle: "(11)"
        )
    )
}
