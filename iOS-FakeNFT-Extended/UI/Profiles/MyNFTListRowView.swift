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
    static let starFilled = Color(.universalYellow)
    static let starEmpty = Color(.dayNightLightGray)
}

struct MyNFTListRowView: View {
    let nft: Nft
    let isLiked: Bool
    
    @Environment(\.locale) private var locale

    private var clampedRating: Int {
        min(5, max(0, nft.rating))
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
                .foregroundStyle(isLiked ? Color.universalRed : Color.universalWhite)
                .padding(6)
        }
    }

    private var middleColumn: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(nft.name)
                .font(.dsBodyBold)
                .foregroundStyle(.dayNightBlack)
                .lineLimit(1)

            MyNFTRatingStarsView(rating: clampedRating)

            Text(authorLine)
                .font(.dsCaption1)
                .foregroundStyle(.dayNightBlack)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var authorLine: String {
        let prefix = NSLocalizedString("MyNFT.authorPrefix", comment: "")
        return "\(prefix) \(nft.author)"
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
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal

        let numberPart = formatter.string(from: NSNumber(value: nft.price))
            ?? String(format: "%.2f", locale: locale, arguments: [nft.price])

        let currency = NSLocalizedString("MyNFT.priceCurrency", comment: "")
        return "\(numberPart) \(currency)"
    }

    private var previewImage: some View {
        AsyncImage(url: nft.previewImageURL) { phase in
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

// MARK: - Rating

private struct MyNFTRatingStarsView: View {
    let rating: Int

    private let maxStars = 5

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0 ..< maxStars, id: \.self) { index in
                Image(systemName: "star.fill")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(
                        index < rating
                            ? MyNFTListRowViewLayout.starFilled
                            : MyNFTListRowViewLayout.starEmpty
                    )
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            String(
                format: NSLocalizedString("MyNFT.ratingAccessibilityFormat", comment: ""),
                locale: .current,
                rating,
                maxStars
            )
        )
    }
}

#Preview("MyNFTListRowView") {
    List {
        MyNFTListRowView(
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
            isLiked: true
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
