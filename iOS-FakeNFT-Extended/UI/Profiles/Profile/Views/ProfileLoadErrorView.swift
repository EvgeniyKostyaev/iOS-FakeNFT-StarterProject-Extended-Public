//
//  ProfileLoadErrorView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 13.04.2026.
//

import SwiftUI

private enum ProfileLoadErrorViewTheme {
    static let contentSpacing: CGFloat = 16
}

struct ProfileLoadErrorView: View {
    @Bindable var viewModel: ProfileLoadErrorViewModel

    var body: some View {
        VStack(spacing: ProfileLoadErrorViewTheme.contentSpacing) {
            Text(viewModel.message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.dayNightBlack)
            Button(NSLocalizedString("Error.repeat", comment: "")) {
                viewModel.repeatTapped()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.dayNightWhite.ignoresSafeArea())
    }
}

#Preview {
    ProfileLoadErrorView(
        viewModel: ProfileLoadErrorViewModel(message: "Preview error message") {}
    )
}
