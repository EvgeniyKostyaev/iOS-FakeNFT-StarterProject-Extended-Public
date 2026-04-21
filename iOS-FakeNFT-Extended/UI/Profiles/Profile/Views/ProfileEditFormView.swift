//
//  ProfileEditFormView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 17.04.2026.
//

import SwiftUI

private enum ProfileEditFormViewTheme {
    static let sectionSpacing: CGFloat = 24
    static let fieldGroupSpacing: CGFloat = 4
    static let descriptionEditorMinHeight: CGFloat = 132
    static let horizontalPadding: CGFloat = 16
    static let bottomPadding: CGFloat = 24
}

struct ProfileEditFormView: View {
    @Bindable var viewModel: ProfileEditViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ProfileEditFormViewTheme.sectionSpacing) {
                ProfileEditAvatarView(viewModel: viewModel)

                VStack(alignment: .leading, spacing: ProfileEditFormViewTheme.fieldGroupSpacing) {
                    ProfileEditLabeledFieldView(titleKey: "Common.name") {
                        TextField("", text: $viewModel.name)
                            .textInputAutocapitalization(.words)
                    }
                    validationHint(viewModel.nameValidationMessage)
                }

                ProfileEditLabeledFieldView(titleKey: "Common.description") {
                    TextEditor(text: $viewModel.description)
                        .frame(
                            minHeight: ProfileEditFormViewTheme.descriptionEditorMinHeight,
                            alignment: .topLeading
                        )
                        .scrollContentBackground(.hidden)
                }

                VStack(alignment: .leading, spacing: ProfileEditFormViewTheme.fieldGroupSpacing) {
                    ProfileEditLabeledFieldView(titleKey: "Common.website") {
                        TextField("", text: $viewModel.websiteText)
                            .keyboardType(.URL)
                            .textContentType(.URL)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                    }
                    validationHint(viewModel.websiteValidationMessage)
                }
            }
            .padding(.horizontal, ProfileEditFormViewTheme.horizontalPadding)
            .padding(.bottom, ProfileEditFormViewTheme.bottomPadding)
        }
        .onChange(of: viewModel.name) { _, _ in
            viewModel.clearNameValidationMessage()
        }
        .onChange(of: viewModel.websiteText) { _, _ in
            viewModel.clearWebsiteValidationMessage()
        }
    }

    @ViewBuilder
    private func validationHint(_ message: String?) -> some View {
        if let message {
            Text(message)
                .font(.dsCaption2)
                .foregroundStyle(Color.red)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    @Previewable @State var viewModel = ProfileEditViewModel(
        profile: .profileScreenMock,
        profileService: ProfileServiceStub()
    )

    ProfileEditFormView(viewModel: viewModel)
        .background(Color.dayNightWhite.ignoresSafeArea())
}
