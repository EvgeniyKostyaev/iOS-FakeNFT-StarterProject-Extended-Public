//
//  NFTItemCellView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 21.04.2026.
//

import SwiftUI

private enum NFTItemCellViewTheme {
    static let contentSpacing: CGFloat = 8
    static let imageHeight: CGFloat = 108
    static let imageCornerRadius: CGFloat = 12
    static let iconPadding: CGFloat = 8
    static let iconSize: CGFloat = 20
    static let starsSpacing: CGFloat = 2
    static let starSize: CGFloat = 10
    static let priceSpacing: CGFloat = 2
    static let minSpacerLength: CGFloat = 8
}

struct NFTItemCellView: View {
    let itemViewData: CollectionNFTViewData
    
    init(itemViewData: CollectionNFTViewData) {
        self.itemViewData = itemViewData
    }

    var body: some View {
        VStack(alignment: .leading, spacing: NFTItemCellViewTheme.contentSpacing) {
            ZStack(alignment: .topTrailing) {
                nftImage
                    .frame(maxWidth: .infinity)
                    .frame(height: NFTItemCellViewTheme.imageHeight)
                    .clipShape(RoundedRectangle(cornerRadius: NFTItemCellViewTheme.imageCornerRadius))

                Image(systemName: itemViewData.isFavorite ? "heart.fill" : "heart")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: NFTItemCellViewTheme.iconSize,
                        height: NFTItemCellViewTheme.iconSize
                    )
                    .foregroundStyle(Color(.universalWhite))
                    .padding(NFTItemCellViewTheme.iconPadding)
            }

            HStack(spacing: NFTItemCellViewTheme.starsSpacing) {
                ForEach(0..<5, id: \.self) { index in
                    Image(systemName: index < itemViewData.rating ? "star.fill" : "star")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: NFTItemCellViewTheme.starSize,
                            height: NFTItemCellViewTheme.starSize
                        )
                        .foregroundStyle(
                            index < itemViewData.rating
                            ? Color(.universalYellow)
                            : Color(.dayNightLightGray)
                        )
                }
            }

            Text(itemViewData.title)
                .font(.dsHeadline3)
                .foregroundStyle(Color(.dayNightBlack))
                .lineLimit(1)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: NFTItemCellViewTheme.priceSpacing) {
                    Text("\(itemViewData.price.formattedPriceETH) \(String(localized: "NFT.currency.eth"))")
                        .font(.dsCaption1)
                        .foregroundStyle(Color(.dayNightBlack))
                }

                Spacer(minLength: NFTItemCellViewTheme.minSpacerLength)

                Image(systemName: itemViewData.isInCart ? "cart.badge.minus" : "cart")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: NFTItemCellViewTheme.iconSize,
                        height: NFTItemCellViewTheme.iconSize
                    )
                    .foregroundStyle(Color(.dayNightBlack))
            }
        }
    }

    @ViewBuilder
    private var nftImage: some View {
        switch itemViewData.imageType {
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
                RoundedRectangle(cornerRadius: NFTItemCellViewTheme.imageCornerRadius)
                    .fill(Color(.dayNightLightGray))
                    .overlay {
                        ProgressView()
                    }
            }
        }
    }
}

#Preview {
    NFTItemCellView(
        itemViewData: CollectionNFTViewData(
            id: "1",
            title: "Archie",
            imageType: .local(.collectionWhite),
            rating: 2,
            price: 1,
            isFavorite: true,
            isInCart: false
        )
    )
    .padding()
}

private extension Decimal {
    var formattedPriceETH: String {
        NSDecimalNumber(decimal: self).stringValue
    }
}
