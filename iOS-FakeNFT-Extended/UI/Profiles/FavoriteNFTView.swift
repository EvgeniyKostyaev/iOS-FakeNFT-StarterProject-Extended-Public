//
//  FavoriteNFTView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 14.04.2026.
//

import SwiftUI
struct FavoriteNFTView: View {
    let profile: ProfileScreen
    var body: some View {
        Color.clear
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.whiteTheme).ignoresSafeArea())
            .navigationTitle(NSLocalizedString("Profile.favoritesNavTitle", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
    }
}
#Preview {
    NavigationStack {
        FavoriteNFTView(profile: .profileScreenMock)
    }
}
