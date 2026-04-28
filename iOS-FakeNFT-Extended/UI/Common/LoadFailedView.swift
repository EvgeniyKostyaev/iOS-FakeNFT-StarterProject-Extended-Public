//
//  LoadFailedView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 28.04.2026.
//

import SwiftUI

private enum LoadFailedViewTheme {
    static let contentSpacing: CGFloat = 16
    static let defaultHorizontalPadding: CGFloat = 16
}

struct LoadFailedView: View {
    let message: String
    let retryAction: () -> Void

    var horizontalPadding: CGFloat = LoadFailedViewTheme.defaultHorizontalPadding
    var expandsVertically: Bool = true

    var body: some View {
        VStack(spacing: LoadFailedViewTheme.contentSpacing) {
            Text(message)
                .font(.dsBodyRegular)
                .foregroundStyle(.dayNightBlack)
                .multilineTextAlignment(.center)

            Button(NSLocalizedString("Error.repeat", comment: "")) {
                retryAction()
            }
            .font(.dsBodySemibold)
        }
        .padding(.horizontal, horizontalPadding)
        .frame(
            maxWidth: .infinity,
            maxHeight: expandsVertically ? .infinity : nil
        )
        .background(Color.dayNightWhite.ignoresSafeArea())
    }
}

#Preview {
    LoadFailedView(message: "Preview error message", retryAction: {})
}
