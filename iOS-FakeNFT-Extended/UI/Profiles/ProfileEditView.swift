//
//  ProfileEditView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 14.04.2026.
//

import SwiftUI
/// Экран редактирования профиля (форма и сохранение — следующие задачи эпика).
struct ProfileEditView: View {
    let profile: ProfileScreen
    var body: some View {
        Spacer()
            .padding(.top, 160)
        Text("Экран редактирования профиля")
        Color.clear
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.whiteTheme).ignoresSafeArea())
    }
}
#Preview {
    NavigationStack {
        ProfileEditView(profile: .profileScreenMock)
    }
}

