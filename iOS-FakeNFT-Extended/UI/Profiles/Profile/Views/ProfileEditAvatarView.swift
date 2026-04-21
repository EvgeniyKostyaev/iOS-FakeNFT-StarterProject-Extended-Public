//
//  ProfileEditAvatarView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 14.04.2026.
//

import SwiftUI

private enum ProfileEditAvatarViewTheme {
    static let imageWidth: CGFloat = 22
    static let imageHeight: CGFloat = 22
    static let overlayStrokeWidth: CGFloat = 2
    static let overlayOffsetX: CGFloat = -3
    static let overlayOffsetY: CGFloat = -3
}

struct ProfileEditAvatarView: View {
    @Bindable var viewModel: ProfileEditViewModel

    var body: some View {
        HStack {
            Spacer()
            Button {
                viewModel.avatarButtonTapped()
            } label: {
                ZStack(alignment: .bottomTrailing) {
                    ProfileAvatarView(avatarURL: viewModel.avatarPreviewURL)

                    Image(systemName: "camera.fill")
                        .font(.dsCaption3Bold)
                        .foregroundStyle(.dayNightBlack)
                        .frame(
                            width: ProfileEditAvatarViewTheme.imageWidth,
                            height: ProfileEditAvatarViewTheme.imageHeight
                        )
                        .background(Color.dayNightLightGray, in: Circle())
                        .overlay(
                            Circle().stroke(
                                Color.dayNightLightGray,
                                lineWidth: ProfileEditAvatarViewTheme.overlayStrokeWidth
                            )
                        )
                        .offset(
                            x: ProfileEditAvatarViewTheme.overlayOffsetX,
                            y: ProfileEditAvatarViewTheme.overlayOffsetY
                        )
                }
            }
            .buttonStyle(.plain)
            Spacer()
        }
    }
}

#Preview {
    @Previewable @State var viewModel = ProfileEditViewModel(
        profile: .profileScreenMock,
        profileService: ProfileServiceStub()
    )

    ZStack {
        Color.dayNightWhite.ignoresSafeArea()
        ProfileEditAvatarView(viewModel: viewModel)
    }
}
