//
//  ProfileHeaderBlockView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 13.04.2026.
//

import SwiftUI

struct ProfileHeaderBlockView: View {
    let profile: ProfileScreen

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .center, spacing: 16) {
                ProfileAvatarView(avatarURL: profile.avatarURL)

                Text(profile.name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.dayNightBlack)
            }

            Text(profile.description)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.dayNightBlack)
                .lineSpacing(4)
        }
    }
}

#Preview {
    List {
        ProfileHeaderBlockView(profile: .profileScreenMock)
            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
    }
    .listStyle(.plain)
    .scrollContentBackground(.hidden)
}
