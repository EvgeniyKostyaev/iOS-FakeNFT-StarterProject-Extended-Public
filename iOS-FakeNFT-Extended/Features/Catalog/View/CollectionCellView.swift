//
//  CollectionCellView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 21.04.2026.
//

import SwiftUI

private enum CollectionCellViewTheme {
    static let cornerRadius: CGFloat = 12
    static let coverViewHeight: CGFloat = 140
}

struct CollectionCellView: View {
    private let itemViewData: CollectionViewData
    
    init(itemViewData: CollectionViewData) {
        self.itemViewData = itemViewData
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            NFTImageView(imageSourceType: itemViewData.coverImageType)
                .frame(height: CollectionCellViewTheme.coverViewHeight, alignment: .top)
                .clipShape(RoundedRectangle(cornerRadius: CollectionCellViewTheme.cornerRadius))
            Text("\(itemViewData.title) (\(itemViewData.nftCount))")
                .font(Font.dsBodyBold)
        }
    }
}

#Preview {
    CollectionCellView(
        itemViewData: CollectionViewData(
            id: "1",
            title: "Peach",
            coverImageType: .local(.collectionPeach),
            nftCount: 11
        )
    )
}
