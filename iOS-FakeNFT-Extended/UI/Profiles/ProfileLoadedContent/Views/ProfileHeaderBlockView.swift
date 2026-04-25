//
//  ProfileHeaderBlockView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 13.04.2026.
//

import SwiftUI

private enum ProfileHeaderBlockViewTheme {
    static let blockVerticalSpacing: CGFloat = 20
    static let avatarNameSpacing: CGFloat = 16
    static let descriptionLineSpacing: CGFloat = 4
    static let previewListHorizontalInset: CGFloat = 16
}

struct ProfileHeaderBlockView: View {
    let profile: ProfileScreen

    var body: some View {
        VStack(alignment: .leading, spacing: ProfileHeaderBlockViewTheme.blockVerticalSpacing) {
            HStack(alignment: .center, spacing: ProfileHeaderBlockViewTheme.avatarNameSpacing) {
                ProfileAvatarView(avatarURL: profile.avatarURL)

                Text(profile.name)
                    .font(.dsHeadline3)
                    .foregroundStyle(.dayNightBlack)
            }

            Text(profile.description)
                .font(.dsCaption2)
                .foregroundStyle(.dayNightBlack)
                .lineSpacing(ProfileHeaderBlockViewTheme.descriptionLineSpacing)
        }
    }
}

#Preview {
    List {
        ProfileHeaderBlockView(profile: .profileScreenMock)
            .listRowInsets(
                EdgeInsets(
                    top: 0,
                    leading: ProfileHeaderBlockViewTheme.previewListHorizontalInset,
                    bottom: 0,
                    trailing: ProfileHeaderBlockViewTheme.previewListHorizontalInset
                )
            )
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
    }
    .listStyle(.plain)
    .scrollContentBackground(.hidden)
}
