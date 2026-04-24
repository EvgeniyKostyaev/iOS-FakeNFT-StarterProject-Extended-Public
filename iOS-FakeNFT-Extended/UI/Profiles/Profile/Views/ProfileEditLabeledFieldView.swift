//
//  ProfileEditLabeledFieldView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 17.04.2026.
//

import SwiftUI

private enum ProfileEditLabeledFieldViewTheme {
    static let titleContentSpacing: CGFloat = 8
    static let fieldHorizontalPadding: CGFloat = 16
    static let fieldVerticalPadding: CGFloat = 12
    static let fieldCornerRadius: CGFloat = 16
    static let previewSectionSpacing: CGFloat = 24
}

struct ProfileEditLabeledFieldView<Content: View>: View {
    let titleKey: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: ProfileEditLabeledFieldViewTheme.titleContentSpacing) {
            Text(NSLocalizedString(titleKey, comment: ""))
                .font(.dsHeadline3)
                .foregroundStyle(.dayNightBlack)

            content()
                .font(.dsBodyRegular)
                .foregroundStyle(.dayNightBlack)
                .padding(.horizontal, ProfileEditLabeledFieldViewTheme.fieldHorizontalPadding)
                .padding(.vertical, ProfileEditLabeledFieldViewTheme.fieldVerticalPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(
                        cornerRadius: ProfileEditLabeledFieldViewTheme.fieldCornerRadius,
                        style: .continuous
                    )
                        .fill(Color.dayNightLightGray)
                )
        }
    }
}

#Preview {
    @Previewable @State var name = "Joaquin Phoenix"
    @Previewable @State var website = "https://example.com"

    ScrollView {
        VStack(alignment: .leading, spacing: ProfileEditLabeledFieldViewTheme.previewSectionSpacing) {
            ProfileEditLabeledFieldView(titleKey: "Common.name") {
                TextField("", text: $name)
                    .textInputAutocapitalization(.words)
            }

            ProfileEditLabeledFieldView(titleKey: "Common.website") {
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
