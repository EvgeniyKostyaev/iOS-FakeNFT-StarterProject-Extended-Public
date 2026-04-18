//
//  ProfileEditLabeledField.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 17.04.2026.
//

import SwiftUI

struct ProfileEditLabeledField<Content: View>: View {
    let titleKey: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(NSLocalizedString(titleKey, comment: ""))
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.dayNightBlack)

            content()
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(.dayNightBlack)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.dayNightLightGray)
                )
        }
    }
}

#Preview {
    @Previewable @State var name = "Joaquin Phoenix"
    @Previewable @State var website = "https://example.com"

    ScrollView {
        VStack(alignment: .leading, spacing: 24) {
            ProfileEditLabeledField(titleKey: "Profile.editName") {
                TextField("", text: $name)
                    .textInputAutocapitalization(.words)
            }

            ProfileEditLabeledField(titleKey: "Profile.editWebsite") {
                TextField("", text: $website)
                    .keyboardType(.URL)
                    .textContentType(.URL)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
        }
        .padding()
    }
    .background(Color.dayNightWhite.ignoresSafeArea())
}
