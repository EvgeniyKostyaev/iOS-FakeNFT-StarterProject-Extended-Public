//
//  ProfileAvatarView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 13.04.2026.
//

import SwiftUI

private enum ProfileAvatarViewTheme {
    static let defaultSideLength: CGFloat = 70
    static let previewStackSpacing: CGFloat = 16
}

struct ProfileAvatarView: View {
    let avatarURL: URL?
    var sideLength: CGFloat = ProfileAvatarViewTheme.defaultSideLength

    var body: some View {
        Group {
            if let url = avatarURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: sideLength, height: sideLength)
                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        placeholder
                    @unknown default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .frame(width: sideLength, height: sideLength)
        .clipShape(Circle())
    }

    private var placeholder: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFit()
            .foregroundStyle(.dayNightLightGray)
    }
}

#Preview {
    VStack(spacing: ProfileAvatarViewTheme.previewStackSpacing) {
        ProfileAvatarView(avatarURL: nil)
        
        ProfileAvatarView(
            avatarURL: ProfileScreen.profileScreenMock.avatarURL
        )
    }
    .padding()
}
