//
//  ProfileEditSaveButtonView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 17.04.2026.
//

import SwiftUI

private enum ProfileEditSaveButtonViewTheme {
    static let labelVerticalPadding: CGFloat = 16
    static let cornerRadius: CGFloat = 16
    static let outerHorizontalPadding: CGFloat = 16
    static let outerVerticalPadding: CGFloat = 12
    static let previewStackSpacing: CGFloat = 16
}

struct ProfileEditSaveButtonView: View {
    @Bindable var viewModel: ProfileEditViewModel

    var body: some View {
        Button {
            Task {
                await viewModel.saveEditorAndDismissIfSucceeded()
            }
        } label: {
            Text(NSLocalizedString("Common.save", comment: ""))
                .font(.dsBodyBold)
                .foregroundStyle(.dayNightWhite)
                .frame(maxWidth: .infinity)
                .padding(.vertical, ProfileEditSaveButtonViewTheme.labelVerticalPadding)
                .background(
                    Color.dayNightBlack,
                    in: RoundedRectangle(
                        cornerRadius: ProfileEditSaveButtonViewTheme.cornerRadius,
                        style: .continuous
                    )
                )
        }
        .padding(.horizontal, ProfileEditSaveButtonViewTheme.outerHorizontalPadding)
        .padding(.vertical, ProfileEditSaveButtonViewTheme.outerVerticalPadding)
        .background(Color.dayNightWhite)
    }
}

#Preview {
    @Previewable @State var viewModel = ProfileEditViewModel(
        profile: .profileScreenMock,
        profileService: ProfileServiceStub()
    )

    VStack(spacing: ProfileEditSaveButtonViewTheme.previewStackSpacing) {
        ProfileEditSaveButtonView(viewModel: viewModel)
    }
    .padding()
    .background(Color.dayNightWhite.ignoresSafeArea())
}
