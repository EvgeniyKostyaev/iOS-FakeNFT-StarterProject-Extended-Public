//
//  ProfilePhotoLinkAlertView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 17.04.2026.
//

import SwiftUI

private enum ProfilePhotoLinkAlertViewTheme {
    static let dimmedOverlayOpacity: CGFloat = 0.4
    static let separatorOpacity: CGFloat = 0.12
    static let titleHorizontalPadding: CGFloat = 16
    static let titleTopPadding: CGFloat = 20
    static let titleBottomPadding: CGFloat = 12
    static let textFieldHorizontalPadding: CGFloat = 12
    static let textFieldVerticalPadding: CGFloat = 10
    static let textFieldCornerRadius: CGFloat = 11
    static let textFieldOuterHorizontalPadding: CGFloat = 16
    static let textFieldOuterBottomPadding: CGFloat = 16
    static let horizontalSeparatorHeight: CGFloat = 1
    static let verticalSeparatorWidth: CGFloat = 1
    static let buttonRowHeight: CGFloat = 48
    static let cardMaxWidth: CGFloat = 300
    static let cardCornerRadius: CGFloat = 16
}

struct ProfilePhotoLinkAlertView: View {
    @Bindable var viewModel: ProfileEditViewModel

    private var separatorColor: Color {
        Color.dayNightBlack.opacity(ProfilePhotoLinkAlertViewTheme.separatorOpacity)
    }

    var body: some View {
        ZStack {
            Color.black.opacity(ProfilePhotoLinkAlertViewTheme.dimmedOverlayOpacity)
                .ignoresSafeArea()
                .onTapGesture {
                    viewModel.cancelPhotoLinkEditing()
                }

            VStack(spacing: 0) {
                Text(NSLocalizedString("Profile.avatarLinkTitle", comment: ""))
                    .font(.dsBodySemibold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.dayNightBlack)
                    .padding(.horizontal, ProfilePhotoLinkAlertViewTheme.titleHorizontalPadding)
                    .padding(.top, ProfilePhotoLinkAlertViewTheme.titleTopPadding)
                    .padding(.bottom, ProfilePhotoLinkAlertViewTheme.titleBottomPadding)

                TextField("https://", text: $viewModel.photoLinkDraftURL)
                    .font(.dsBodyRegular)
                    .foregroundStyle(.dayNightBlack)
                    .keyboardType(.URL)
                    .textContentType(.URL)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding(.horizontal, ProfilePhotoLinkAlertViewTheme.textFieldHorizontalPadding)
                    .padding(.vertical, ProfilePhotoLinkAlertViewTheme.textFieldVerticalPadding)
                    .background(
                        RoundedRectangle(
                            cornerRadius: ProfilePhotoLinkAlertViewTheme.textFieldCornerRadius,
                            style: .continuous
                        )
                        .fill(Color.dayNightWhite)
                    )
                    .padding(.horizontal, ProfilePhotoLinkAlertViewTheme.textFieldOuterHorizontalPadding)
                    .padding(.bottom, ProfilePhotoLinkAlertViewTheme.textFieldOuterBottomPadding)

                Rectangle()
                    .fill(separatorColor)
                    .frame(height: ProfilePhotoLinkAlertViewTheme.horizontalSeparatorHeight)
                    .frame(maxWidth: .infinity)

                HStack(spacing: 0) {
                    Button {
                        viewModel.cancelPhotoLinkEditing()
                    } label: {
                        Text(NSLocalizedString("Common.cancel", comment: ""))
                            .font(.dsBodyRegular)
                            .foregroundStyle(.blue)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .buttonStyle(.plain)
                    .frame(height: ProfilePhotoLinkAlertViewTheme.buttonRowHeight)

                    Rectangle()
                        .fill(separatorColor)
                        .frame(
                            width: ProfilePhotoLinkAlertViewTheme.verticalSeparatorWidth,
                            height: ProfilePhotoLinkAlertViewTheme.buttonRowHeight
                        )

                    Button {
                        viewModel.savePhotoLinkDraft()
                    } label: {
                        Text(NSLocalizedString("Common.save", comment: ""))
                            .font(.dsBodyBold)
                            .foregroundStyle(.blue)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .buttonStyle(.plain)
                    .frame(height: ProfilePhotoLinkAlertViewTheme.buttonRowHeight)
                }
            }
            .frame(maxWidth: ProfilePhotoLinkAlertViewTheme.cardMaxWidth)
            .fixedSize(horizontal: false, vertical: true)
            .background(
                RoundedRectangle(
                    cornerRadius: ProfilePhotoLinkAlertViewTheme.cardCornerRadius,
                    style: .continuous
                )
                    .fill(Color.dayNightLightGray)
            )
            .compositingGroup()
        }
        .transition(.opacity)
    }
}

#Preview {
    @Previewable @State var viewModel = ProfileEditViewModel(
        profile: .profileScreenMock,
        profileService: ProfileServiceStub()
    )

    ZStack {
        Color.dayNightLightGray.ignoresSafeArea()
        ProfilePhotoLinkAlertView(viewModel: viewModel)
    }
    .onAppear {
        viewModel.beginPhotoLinkEditing()
        viewModel.photoLinkDraftURL = "https://example.com/photo.jpg"
    }
}
