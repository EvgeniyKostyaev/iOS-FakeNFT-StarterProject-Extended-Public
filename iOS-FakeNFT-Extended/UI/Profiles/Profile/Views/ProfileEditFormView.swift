//
//  ProfileEditFormView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 14.04.2026.
//

import SwiftUI

struct ProfileEditFormView: View {
    @Bindable var viewModel: ProfileEditViewModel
    let onAvatarTap: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ProfileEditAvatarSection(
                    avatarURL: viewModel.avatarPreviewURL,
                    onTap: onAvatarTap
                )

                VStack(alignment: .leading, spacing: 4) {
                    ProfileEditLabeledField(titleKey: "Profile.editName") {
                        TextField("", text: $viewModel.name)
                            .textInputAutocapitalization(.words)
                    }
                    validationHint(viewModel.nameValidationMessage)
                }

                ProfileEditLabeledField(titleKey: "Profile.editDescription") {
                    TextEditor(text: $viewModel.description)
                        .frame(minHeight: 132, alignment: .topLeading)
                        .scrollContentBackground(.hidden)
                }

                VStack(alignment: .leading, spacing: 4) {
                    ProfileEditLabeledField(titleKey: "Profile.editWebsite") {
                        TextField("", text: $viewModel.websiteText)
                            .keyboardType(.URL)
                            .textContentType(.URL)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                    }
                    validationHint(viewModel.websiteValidationMessage)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
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
                .font(.system(size: 13, weight: .regular))
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

    ProfileEditFormView(viewModel: viewModel, onAvatarTap: {})
        .background(Color.dayNightWhite.ignoresSafeArea())
}
