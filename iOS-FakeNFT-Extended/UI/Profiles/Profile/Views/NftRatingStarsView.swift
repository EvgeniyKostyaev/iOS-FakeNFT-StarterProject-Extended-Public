//
//  NftRatingStarsView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 23.04.2026.
//

import SwiftUI

struct NftRatingStarsView: View {
    private let clampedRating: Int
    private let maxStars: Int

    init(rating: Int, maxStars: Int = 5) {
        self.maxStars = max(1, maxStars)
        self.clampedRating = min(self.maxStars, max(0, rating))
    }

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0 ..< maxStars, id: \.self) { index in
                Image(systemName: "star.fill")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(
                        index < clampedRating
                            ? Color(.universalYellow)
                            : Color(.dayNightLightGray)
                    )
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            String(
                format: NSLocalizedString("MyNFT.ratingAccessibilityFormat", comment: ""),
                locale: .current,
                clampedRating,
                maxStars
            )
        )
    }
}

#Preview {
    VStack(spacing: 12) {
        NftRatingStarsView(rating: 0)
        NftRatingStarsView(rating: 3)
        NftRatingStarsView(rating: 5)
    }
    .padding()
}
