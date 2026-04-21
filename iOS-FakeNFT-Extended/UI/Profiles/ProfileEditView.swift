//
//  ProfileEditView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 14.04.2026.
//

import SwiftUI

private enum ProfileEditViewTheme {
    static let contentAnimationDuration: Double = 0.2
    static let overlayZIndexExitConfirmation: CGFloat = 1
    static let overlayZIndexPhotoLink: CGFloat = 2
}

struct ProfileEditView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: ProfileEditViewModel

    init(profile: ProfileScreen, profileService: ProfileService) {
        _viewModel = State(wrappedValue: ProfileEditViewModel(profile: profile, profileService: profileService))
    }

    private var hasUnsavedChanges: Bool {
        viewModel.hasUnsavedTextChanges || viewModel.hasUnsavedAvatarChanges
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ProfileEditFormView(viewModel: viewModel)

                if hasUnsavedChanges, !viewModel.isSaving {
                    ProfileEditSaveButtonView(viewModel: viewModel)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(
                .easeInOut(duration: ProfileEditViewTheme.contentAnimationDuration),
                value: viewModel.isSaving
            )
            .animation(
                .easeInOut(duration: ProfileEditViewTheme.contentAnimationDuration),
                value: hasUnsavedChanges
            )
            .background(Color.dayNightWhite.ignoresSafeArea())

            if viewModel.showExitConfirmation {
                ProfileExitConfirmationView(viewModel: viewModel)
                    .zIndex(ProfileEditViewTheme.overlayZIndexExitConfirmation)
            }

            if viewModel.showPhotoLinkAlert {
                ProfilePhotoLinkAlertView(viewModel: viewModel)
                    .zIndex(ProfileEditViewTheme.overlayZIndexPhotoLink)
            }
        }
        .animation(
            .easeInOut(duration: ProfileEditViewTheme.contentAnimationDuration),
            value: viewModel.showExitConfirmation
        )
        .animation(
            .easeInOut(duration: ProfileEditViewTheme.contentAnimationDuration),
            value: viewModel.showPhotoLinkAlert
        )
        .task {
            await viewModel.loadFormDataFromServer()
        }
        .onAppear {
            viewModel.setEditorDismissAction { dismiss() }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButton {
            viewModel.handleEditorBackNavigation()
        }
        .confirmationDialog(
            NSLocalizedString("Profile.avatarSheetTitle", comment: ""),
            isPresented: $viewModel.showAvatarActions,
            titleVisibility: .visible
        ) {
            Button(NSLocalizedString("Profile.avatarChangePhoto", comment: "")) {
                viewModel.beginPhotoLinkEditing()
            }
            if viewModel.canOfferAvatarDeletion {
                Button(NSLocalizedString("Profile.avatarDeletePhoto", comment: ""), role: .destructive) {
                    viewModel.removeAvatar()
                }
            }
            Button(NSLocalizedString("Common.cancel", comment: ""), role: .cancel) {}
        }
        .alert(
            NSLocalizedString("Error.title", comment: ""),
            isPresented: Binding(
                get: { viewModel.saveErrorMessage != nil },
                set: { if !$0 { viewModel.clearSaveError() } }
            ),
            actions: {
                Button(NSLocalizedString("Error.ok", comment: ""), role: .cancel) {
                    viewModel.clearSaveError()
                }
            },
            message: {
                Text(viewModel.saveErrorMessage ?? "")
            }
        )
    }
}

#Preview {
    NavigationStack {
        ProfileEditView(profile: .profileScreenMock, profileService: ProfileServiceStub())
    }
}
