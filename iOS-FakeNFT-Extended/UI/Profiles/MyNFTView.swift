//
//  MyNFTView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 14.04.2026.
//

import SwiftUI

struct MyNFTView: View {
    let profile: ProfileScreen

    var body: some View {
        Color.clear
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.whiteTheme).ignoresSafeArea())
            .navigationTitle(NSLocalizedString("Profile.myNFTsNavTitle", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        MyNFTView(profile: .profileScreenMock)
    }
}
