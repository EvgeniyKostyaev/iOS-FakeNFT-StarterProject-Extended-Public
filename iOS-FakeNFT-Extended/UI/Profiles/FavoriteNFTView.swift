//
//  FavoriteNFTView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 14.04.2026.
//

import SwiftUI

struct FavoriteNFTView: View {
    @Environment(\.dismiss) private var dismiss

    let profile: ProfileScreen

    var body: some View {
        Color.clear
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.dayNightWhite)
            .customNavigationBar(
                title: NSLocalizedString("Profile.favoritesNavTitle", comment: "")
            ) {
                dismiss()
            }
    }
}

#Preview {
    NavigationStack {
        FavoriteNFTView(profile: .profileScreenMock)
    }
}
