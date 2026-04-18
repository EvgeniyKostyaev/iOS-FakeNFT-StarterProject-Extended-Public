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
            .navigationTitle(NSLocalizedString("Profile.favoritesNavTitle", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.dayNightBlack)
                    }
                    .buttonStyle(.plain)
                }
            }
    }
}

#Preview {
    NavigationStack {
        FavoriteNFTView(profile: .profileScreenMock)
    }
}
