//
//  MyNFTView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 14.04.2026.
//

import SwiftUI

struct MyNFTView: View {
    @Environment(\.dismiss) private var dismiss

    let profile: ProfileScreen

    var body: some View {
        Color.clear
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.dayNightWhite)
            .navigationTitle(NSLocalizedString("Profile.myNFTsNavTitle", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButton {
                dismiss()
            }
    }
}

#Preview {
    NavigationStack {
        MyNFTView(profile: .profileScreenMock)
    }
}
