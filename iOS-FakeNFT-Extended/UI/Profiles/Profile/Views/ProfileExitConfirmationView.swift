//
//  ProfileExitConfirmationView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 16.04.2026.
//

import SwiftUI

private enum ProfileExitConfirmationViewTheme {
    static let dimmedOverlayOpacity: CGFloat = 0.4
    static let separatorOpacity: CGFloat = 0.36
    static let titleHorizontalPadding: CGFloat = 16
    static let titleTopPadding: CGFloat = 20
    static let titleBottomPadding: CGFloat = 16
    static let horizontalSeparatorHeight: CGFloat = 0.5
    static let verticalSeparatorWidth: CGFloat = 0.5
    static let buttonRowHeight: CGFloat = 48
    static let cardMaxWidth: CGFloat = 270
    static let cardCornerRadius: CGFloat = 14
}

struct ProfileExitConfirmationView: View {
    @Bindable var viewModel: ProfileEditViewModel

    private var separatorColor: Color {
        Color.universalBackground.opacity(ProfileExitConfirmationViewTheme.separatorOpacity)
    }

    var body: some View {
        ZStack {
            Color.black.opacity(ProfileExitConfirmationViewTheme.dimmedOverlayOpacity)
                .ignoresSafeArea()
                .onTapGesture {
                    viewModel.exitConfirmationChooseStay()
                }

            VStack(spacing: 0) {
                Text(NSLocalizedString("Profile.editExitTitle", comment: ""))
                    .font(.dsBodySemibold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.universalBlack)
                    .padding(.horizontal, ProfileExitConfirmationViewTheme.titleHorizontalPadding)
                    .padding(.top, ProfileExitConfirmationViewTheme.titleTopPadding)
                    .padding(.bottom, ProfileExitConfirmationViewTheme.titleBottomPadding)

                Rectangle()
                    .fill(separatorColor)
                    .frame(height: ProfileExitConfirmationViewTheme.horizontalSeparatorHeight)
                    .frame(maxWidth: .infinity)

                HStack(spacing: 0) {
                    Button {
                        viewModel.exitConfirmationChooseStay()
                    } label: {
                        Text(NSLocalizedString("Profile.editExitStay", comment: ""))
                            .font(.dsBodyRegular)
                            .foregroundStyle(.blue)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .buttonStyle(.plain)
                    .frame(height: ProfileExitConfirmationViewTheme.buttonRowHeight)

                    Rectangle()
                        .fill(separatorColor)
                        .frame(
                            width: ProfileExitConfirmationViewTheme.verticalSeparatorWidth,
                            height: ProfileExitConfirmationViewTheme.buttonRowHeight
                        )

                    Button {
                        viewModel.exitConfirmationChooseExit()
                    } label: {
                        Text(NSLocalizedString("Common.exit", comment: ""))
                            .font(.dsBodyBold)
                            .foregroundStyle(.blue)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .buttonStyle(.plain)
                    .frame(height: ProfileExitConfirmationViewTheme.buttonRowHeight)
                }
            }
            .frame(maxWidth: ProfileExitConfirmationViewTheme.cardMaxWidth)
            .fixedSize(horizontal: false, vertical: true)
            .background(
                RoundedRectangle(
                    cornerRadius: ProfileExitConfirmationViewTheme.cardCornerRadius,
                    style: .continuous
                )
                    .fill(Color.universalWhite)
            )
        }
        .transition(.opacity)
    }
}

#Preview {
    ProfileExitConfirmationPreviewHost()
}

private struct ProfileExitConfirmationPreviewHost: View {
    @State private var viewModel = ProfileEditViewModel(
        profile: .profileScreenMock,
        profileService: ProfileServiceStub()
    )

    var body: some View {
        ZStack {
            Color.dayNightLightGray.ignoresSafeArea()
            if viewModel.showExitConfirmation {
                ProfileExitConfirmationView(viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.setEditorDismissAction {}
            viewModel.showExitConfirmation = true
        }
    }
}
