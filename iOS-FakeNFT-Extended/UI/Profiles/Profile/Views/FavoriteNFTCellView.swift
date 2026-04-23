//
//  FavoriteNFTCellView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 23.04.2026.
//

import SwiftUI

enum FavoriteNFTGridLayout {
    static let horizontalPadding: CGFloat = 16
    static let columnSpacing: CGFloat = 7
    static let rowSpacing: CGFloat = 20
    static let cellContentSpacing: CGFloat = 8
    static let imageSide: CGFloat = 80
    static let imageCornerRadius: CGFloat = 12
}

struct FavoriteNFTCellView: View {
    let model: FavoriteNFTCellModel
    let onRemoveFromFavorites: () -> Void

    @Environment(\.locale) private var locale

    private var clampedRating: Int {
        min(5, max(0, model.rating))
    }

    var body: some View {
        HStack(alignment: .center, spacing: FavoriteNFTGridLayout.cellContentSpacing) {
            previewWithHeart
            infoColumn
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var previewWithHeart: some View {
        ZStack(alignment: .topTrailing) {
            previewImage
                .frame(width: FavoriteNFTGridLayout.imageSide, height: FavoriteNFTGridLayout.imageSide)
                .clipShape(RoundedRectangle(cornerRadius: FavoriteNFTGridLayout.imageCornerRadius))

            Button(action: onRemoveFromFavorites) {
                Image(systemName: "heart.fill")
                    .font(.dsBodySemibold)
                    .foregroundStyle(Color.universalRed)
                    .padding(4)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(NSLocalizedString("FavoriteNFT.removeFromFavoritesAccessibility", comment: ""))
        }
    }

    private var infoColumn: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(model.name)
                .font(.dsBodyBold)
                .foregroundStyle(.dayNightBlack)
                .lineLimit(1)
                .minimumScaleFactor(0.85)

            NftRatingStarsView(rating: clampedRating)

            Text(formattedPriceLine)
                .font(.dsBodyRegular)
                .foregroundStyle(.dayNightBlack)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var formattedPriceLine: String {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal

        let numberPart = formatter.string(from: NSNumber(value: model.price))
            ?? String(format: "%.2f", locale: locale, arguments: [model.price])

        let currency = NSLocalizedString("MyNFT.priceCurrency", comment: "")
        return "\(numberPart) \(currency)"
    }

    private var previewImage: some View {
        AsyncImage(url: model.previewImageURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                Color.dayNightLightGray
            case .empty:
                Color.dayNightLightGray
                    .overlay {
                        ProgressView()
                    }
            @unknown default:
                Color.dayNightLightGray
            }
        }
    }
}

#Preview("FavoriteNFTCellView") {
    FavoriteNFTCellView(
        model: FavoriteNFTCellModel(
            nft: Nft(
                id: "1",
                name: "Lilo",
                images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/1.png")!],
                rating: 4,
                description: "",
                price: 1.78,
                author: "John Doe",
                website: nil,
                createdAt: nil
            )
        ),
        onRemoveFromFavorites: {}
    )
    .padding()
    .background(Color.dayNightWhite)
}
