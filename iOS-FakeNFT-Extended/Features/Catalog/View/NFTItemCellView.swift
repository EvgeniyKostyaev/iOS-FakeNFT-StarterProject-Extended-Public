//
//  NFTItemCellView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 21.04.2026.
//

import SwiftUI

private enum NFTItemCellViewTheme {
    static let contentSpacing: CGFloat = 8
    static let contentWidth: CGFloat = 108
    static let actionButtonSize: CGFloat = 40
    static let imageHeight: CGFloat = 108
    static let imageCornerRadius: CGFloat = 12
    static let iconSize: CGFloat = 20
    static let starsSpacing: CGFloat = 0
    static let starSize: CGFloat = 12
    static let priceSpacing: CGFloat = 4
    static let lineLimit: Int = 1
}

struct NFTItemCellView: View {
    let itemViewData: CollectionNFTViewData
    
    init(itemViewData: CollectionNFTViewData) {
        self.itemViewData = itemViewData
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: NFTItemCellViewTheme.contentSpacing) {
            ZStack(alignment: .topTrailing) {
                NFTImageView(imageSourceType: itemViewData.imageType)
                    .frame(height: NFTItemCellViewTheme.imageHeight)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: NFTItemCellViewTheme.imageCornerRadius))
                
                Button {
                    
                } label: {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: NFTItemCellViewTheme.iconSize,
                            height: NFTItemCellViewTheme.iconSize
                        )
                        .foregroundStyle(
                            itemViewData.isFavorite
                            ? .universalRed
                            : .universalWhite
                        )
                }
                .frame(
                    width: NFTItemCellViewTheme.actionButtonSize,
                    height: NFTItemCellViewTheme.actionButtonSize
                )
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
            
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: NFTItemCellViewTheme.priceSpacing) {
                    Text(itemViewData.title)
                        .font(.dsBodyBold)
                        .foregroundStyle(Color(.dayNightBlack))
                        .lineLimit(NFTItemCellViewTheme.lineLimit)

                    Text("\(itemViewData.price.formattedPriceETH) \(String(localized: "NFT.currency.eth"))")
                        .font(.dsCaption4Medium)
                        .foregroundStyle(Color(.dayNightBlack))
                        .lineLimit(NFTItemCellViewTheme.lineLimit)
                    
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(itemViewData.isInCart ? .cartMinus : .cart)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: NFTItemCellViewTheme.iconSize,
                            height: NFTItemCellViewTheme.iconSize
                        )
                        .foregroundStyle(Color(.dayNightBlack))
                }
                .frame(
                    width: NFTItemCellViewTheme.actionButtonSize,
                    height: NFTItemCellViewTheme.actionButtonSize
                )
            }
        }
        .frame(width: NFTItemCellViewTheme.contentWidth)
    }
}

#Preview {
    NFTItemCellView(
        itemViewData: CollectionNFTViewData(
            id: "1",
            nftId: "1",
            title: "Archie7777",
            imageType: .remote(URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Clover/1.png")!),
            rating: 5,
            price: 1.567778978,
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
