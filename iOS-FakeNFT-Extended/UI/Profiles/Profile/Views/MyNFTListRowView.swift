//
//  MyNFTListRowView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 23.04.2026.
//

import SwiftUI

enum MyNFTListRowViewLayout {
    static let imageSide: CGFloat = 108
    static let imageCornerRadius: CGFloat = 12
    static let listLeadingPadding: CGFloat = 16
    static let listTrailingPadding: CGFloat = 39
    static let listVerticalPadding: CGFloat = 10
}

struct MyNFTListRowView: View {
    let model: MyNFTListRowModel

    private static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        return formatter
    }()

    @Environment(\.locale) private var locale

    private var clampedRating: Int {
        min(5, max(0, model.rating))
    }

    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            previewWithBadge
            middleColumn
            priceColumn
        }
        .padding(.vertical, 4)
    }

    private var previewWithBadge: some View {
        ZStack(alignment: .topTrailing) {
            previewImage
                .frame(width: MyNFTListRowViewLayout.imageSide, height: MyNFTListRowViewLayout.imageSide)
                .clipShape(RoundedRectangle(cornerRadius: MyNFTListRowViewLayout.imageCornerRadius))

            Image(systemName: "heart.fill")
                .font(.dsBodySemibold)
                .foregroundStyle(model.isLiked ? Color.universalRed : Color.universalWhite)
                .padding(6)
        }
    }

    private var middleColumn: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(model.name)
                .font(.dsBodyBold)
                .foregroundStyle(.dayNightBlack)
                .lineLimit(1)

            NftRatingStarsView(rating: clampedRating)

            Text(authorLine)
                .font(.dsCaption1)
                .foregroundStyle(.dayNightBlack)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var authorLine: String {
        let prefix = NSLocalizedString("MyNFT.authorPrefix", comment: "")
        return "\(prefix) \(model.author)"
    }

    private var priceColumn: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(NSLocalizedString("MyNFT.priceLabel", comment: ""))
                .font(.dsCaption2)
                .foregroundStyle(.dayNightBlack)

            Text(formattedPriceLine)
                .font(.dsBodyBold)
                .foregroundStyle(.dayNightBlack)
        }
        .multilineTextAlignment(.trailing)
    }

    private var formattedPriceLine: String {
        Self.priceFormatter.locale = locale
        let numberPart = Self.priceFormatter.string(from: NSNumber(value: model.price))
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

#Preview("MyNFTListRowView") {
    List {
        MyNFTListRowView(
            model: MyNFTListRowModel(
                nft: Nft(
                    id: "1",
                    name: "Lilo",
                    images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/1.png")!],
                    rating: 3,
                    description: "",
                    price: 1.78,
                    author: "John Doe",
                    website: nil,
                    createdAt: nil
                ),
                likedNFTIds: ["1"]
            )
        )
        .listRowInsets(
            EdgeInsets(
                top: MyNFTListRowViewLayout.listVerticalPadding,
                leading: MyNFTListRowViewLayout.listLeadingPadding,
                bottom: MyNFTListRowViewLayout.listVerticalPadding,
                trailing: MyNFTListRowViewLayout.listTrailingPadding
            )
        )
    }
    .listStyle(.plain)
}
