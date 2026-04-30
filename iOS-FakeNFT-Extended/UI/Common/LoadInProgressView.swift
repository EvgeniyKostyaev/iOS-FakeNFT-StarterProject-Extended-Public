//
//  LoadInProgressView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 28.04.2026.
//

import SwiftUI

private enum LoadInProgressViewTheme {
    static let scaleEffect: CGFloat = 1.5
    static let backgroundOpacity: CGFloat = 0.8
}

struct LoadInProgressView: View {
    var body: some View {
        ProgressView()
            .scaleEffect(LoadInProgressViewTheme.scaleEffect)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color(.systemBackground)
                    .opacity(LoadInProgressViewTheme.backgroundOpacity)
            )
    }
}

#Preview {
    LoadInProgressView()
}
