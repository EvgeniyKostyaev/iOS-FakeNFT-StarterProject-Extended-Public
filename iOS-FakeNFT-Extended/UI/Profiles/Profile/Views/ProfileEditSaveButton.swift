//
//  ProfileEditSaveButton.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 14.04.2026.
//

import SwiftUI

struct ProfileEditSaveButton: View {
    let isSaving: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(NSLocalizedString("Profile.editSave", comment: ""))
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.dayNightWhite)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.dayNightBlack, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .disabled(isSaving)
        .opacity(isSaving ? 0.5 : 1)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.dayNightWhite)
    }
}

#Preview {
    VStack(spacing: 16) {
        ProfileEditSaveButton(isSaving: false) {}
    }
    .padding()
    .background(Color.dayNightWhite.ignoresSafeArea())
}
