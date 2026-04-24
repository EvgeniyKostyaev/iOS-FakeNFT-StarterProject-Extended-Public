//
//  NFTItemCellView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 21.04.2026.
//

import SwiftUI

struct NFTItemCellView: View {
    let itemViewData: CollectionNFTViewData

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                nftImage
                    .frame(maxWidth: .infinity)
                    .frame(height: 108)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Image(systemName: itemViewData.isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color(.universalWhite))
                    .padding(8)
            }

            HStack(spacing: 2) {
                ForEach(0..<5, id: \.self) { index in
                    Image(systemName: index < itemViewData.rating ? "star.fill" : "star")
                        .font(.system(size: 10))
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
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(itemViewData.price.formattedPriceETH) \(String(localized: "NFT.currency.eth"))")
                        .font(.dsCaption1)
                        .foregroundStyle(Color(.dayNightBlack))
                }

                Spacer(minLength: 8)

                Image(systemName: itemViewData.isInCart ? "cart.badge.minus" : "cart")
                    .font(.system(size: 20, weight: .regular))
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
                RoundedRectangle(cornerRadius: 12)
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
