//
//  ProfileEditAvatarSection.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 14.04.2026.
//

import SwiftUI

struct ProfileEditAvatarSection: View {
    let avatarURL: URL?
    let onTap: () -> Void

    var body: some View {
        HStack {
            Spacer()
            Button(action: onTap) {
                ZStack(alignment: .bottomTrailing) {
                    ProfileAvatarView(avatarURL: avatarURL)

                    Image(systemName: "camera.fill")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.dayNightBlack)
                        .frame(width: 22, height: 22)
                        .background(Color.dayNightLightGray, in: Circle())
                        .overlay(Circle().stroke(Color.dayNightLightGray, lineWidth: 2))
                        .offset(x: -3, y: -3)
                }
            }
            .buttonStyle(.plain)
            Spacer()
        }
    }
}

#Preview {
    ZStack {
        Color.dayNightWhite.ignoresSafeArea()
        ProfileEditAvatarSection(
            avatarURL: ProfileScreen.profileScreenMock.avatarURL,
            onTap: {}
        )
    }
}
