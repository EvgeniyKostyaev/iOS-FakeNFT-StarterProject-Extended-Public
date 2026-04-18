//
//  ProfileEditView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 14.04.2026.
//

import SwiftUI

struct ProfileEditView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: ProfileEditViewModel
    @State private var showExitConfirmation = false
    @State private var showAvatarActions = false
    @State private var showPhotoLinkAlert = false
    @State private var linkDraftURL = ""

    init(profile: ProfileScreen, profileService: ProfileService) {
        _viewModel = State(wrappedValue: ProfileEditViewModel(profile: profile, profileService: profileService))
    }

    private var hasUnsavedChanges: Bool {
        viewModel.hasUnsavedTextChanges || viewModel.hasUnsavedAvatarChanges
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ProfileEditFormView(viewModel: viewModel) {
                    showAvatarActions = true
                }

                if hasUnsavedChanges, !viewModel.isSaving {
                    ProfileEditSaveButton {
                        Task {
                            if await viewModel.performSave() {
                                dismiss()
                            }
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: viewModel.isSaving)
            .animation(.easeInOut(duration: 0.2), value: hasUnsavedChanges)
            .background(Color.dayNightWhite.ignoresSafeArea())

            if showExitConfirmation {
                ProfileExitConfirmationView(
                    isPresented: $showExitConfirmation,
                    onStay: {},
                    onExit: { dismiss() }
                )
                .zIndex(1)
            }

            if showPhotoLinkAlert {
                ProfilePhotoLinkAlertView(
                    isPresented: $showPhotoLinkAlert,
                    urlString: $linkDraftURL,
                    onCancel: {},
                    onSave: { viewModel.applyManualAvatarURL(linkDraftURL) }
                )
                .zIndex(2)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showExitConfirmation)
        .animation(.easeInOut(duration: 0.2), value: showPhotoLinkAlert)
        .task {
            await viewModel.loadFormDataFromServer()
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    if hasUnsavedChanges {
                        showExitConfirmation = true
                    } else {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.dayNightBlack)
                }
            }
        }
        .confirmationDialog(
            NSLocalizedString("Profile.avatarSheetTitle", comment: ""),
            isPresented: $showAvatarActions,
            titleVisibility: .visible
        ) {
            Button(NSLocalizedString("Profile.avatarChangePhoto", comment: "")) {
                linkDraftURL = viewModel.manualAvatarURLString
                showPhotoLinkAlert = true
            }
            Button(NSLocalizedString("Profile.avatarDeletePhoto", comment: ""), role: .destructive) {
                viewModel.removeAvatar()
            }
            Button(NSLocalizedString("Profile.avatarSheetDismiss", comment: ""), role: .cancel) {}
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
