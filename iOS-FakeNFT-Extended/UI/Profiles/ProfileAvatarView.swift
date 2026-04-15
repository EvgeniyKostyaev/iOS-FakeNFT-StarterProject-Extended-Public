//
//  ProfileAvatarView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 13.04.2026.
//

import SwiftUI

struct ProfileAvatarView: View {
    let avatarURL: URL?

    var body: some View {
        Group {
            if let url = avatarURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 70, height: 70)
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
        .frame(width: 70, height: 70)
        .clipShape(Circle())
    }

    private var placeholder: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFit()
            .foregroundStyle(.dayNightLightGray)
    }
}
