//
//  ProfileEditView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 14.04.2026.
//

import SwiftUI

struct ProfileEditView: View {
    let profile: ProfileScreen
    var body: some View {
        VStack {
            Spacer()
                .padding(.top, 160)
            Text("Экран редактирования профиля")
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color(.dayNightWhite).ignoresSafeArea())
    }
}

#Preview {
    NavigationStack {
        ProfileEditView(profile: .profileScreenMock)
    }
}
