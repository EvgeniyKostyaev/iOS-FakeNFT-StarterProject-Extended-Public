//
//  ProfileEditViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 16.04.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class ProfileEditViewModel {

    var name: String
    var description: String
    var websiteText: String

    var manualAvatarURLString: String

    var avatarDeleted: Bool

    var showAvatarActions = false

    var showExitConfirmation = false

    var showPhotoLinkAlert = false
    var photoLinkDraftURL = ""

    private(set) var isSaving = false
    private(set) var saveErrorMessage: String?

    private(set) var nameValidationMessage: String?
    private(set) var websiteValidationMessage: String?

    private let profileService: ProfileService

    private var baselineProfile: ProfileScreen

    private var dismissEditor: (() -> Void)?

    init(profile: ProfileScreen, profileService: ProfileService) {
        self.profileService = profileService
        baselineProfile = profile
        avatarDeleted = false

        name = profile.name
        description = profile.description
        websiteText = profile.websiteURL.absoluteString
        manualAvatarURLString = profile.avatarURL?.absoluteString ?? ""
    }

    func loadFormDataFromServer() async {
        if let fresh = try? await profileService.loadProfile(userId: ProfileAPIPath.gatewayProfilePathSegment) {
            applyFreshProfile(fresh)
        }
    }

    var avatarPreviewURL: URL? {
        if avatarDeleted { return nil }
        let trimmed = normalized(manualAvatarURLString)
        if let url = URL(string: trimmed), !trimmed.isEmpty {
            return url
        }
        return baselineProfile.avatarURL
    }

    var canOfferAvatarDeletion: Bool {
        avatarPreviewURL != nil
    }

    var hasUnsavedTextChanges: Bool {
        normalized(name) != normalized(baselineProfile.name)
            || normalized(description) != normalized(baselineProfile.description)
            || normalized(websiteText) != normalized(baselineProfile.websiteURL.absoluteString)
    }

    var hasUnsavedAvatarChanges: Bool {
        if avatarDeleted {
            return baselineProfile.avatarURL != nil
        }
        return normalized(manualAvatarURLString)
            != normalized(baselineProfile.avatarURL?.absoluteString ?? "")
    }

    func avatarValueForPutRequest() -> String {
        if avatarDeleted {
            return ""
        }
        return normalized(manualAvatarURLString)
    }

    func removeAvatar() {
        avatarDeleted = true
        manualAvatarURLString = ""
    }

    func avatarButtonTapped() {
        showAvatarActions = true
    }

    func handleEditorBackNavigation() {
        if hasUnsavedTextChanges || hasUnsavedAvatarChanges {
            showExitConfirmation = true
        } else {
            dismissEditor?()
        }
    }

    func exitConfirmationChooseStay() {
        showExitConfirmation = false
    }

    func exitConfirmationChooseExit() {
        showExitConfirmation = false
        dismissEditor?()
    }

    func setEditorDismissAction(_ action: @escaping () -> Void) {
        dismissEditor = action
    }

    func beginPhotoLinkEditing() {
        photoLinkDraftURL = manualAvatarURLString
        showPhotoLinkAlert = true
    }

    func cancelPhotoLinkEditing() {
        showPhotoLinkAlert = false
    }

    func savePhotoLinkDraft() {
        applyManualAvatarURL(photoLinkDraftURL)
        showPhotoLinkAlert = false
    }

    func saveEditorAndDismissIfSucceeded() async {
        guard await performSave() else { return }
        dismissEditor?()
    }

    func applyManualAvatarURL(_ raw: String) {
        manualAvatarURLString = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        avatarDeleted = false
    }

    func clearSaveError() {
        saveErrorMessage = nil
    }

    func clearFieldValidationErrors() {
        nameValidationMessage = nil
        websiteValidationMessage = nil
    }

    func clearNameValidationMessage() {
        nameValidationMessage = nil
    }

    func clearWebsiteValidationMessage() {
        websiteValidationMessage = nil
    }

    @discardableResult
    func performSave() async -> Bool {
        guard !isSaving else { return false }
        saveErrorMessage = nil
        clearFieldValidationErrors()
        guard validateForSave() else { return false }

        isSaving = true
        defer { isSaving = false }

        do {
            let payload = ProfileUpdatePayload(
                name: normalized(name),
                description: normalized(description),
                website: websiteValueForPutRequest(),
                avatar: avatarValueForPutRequest(),
                likes: baselineProfile.likes,
                nfts: baselineProfile.nfts
            )
            try await profileService.updateProfile(payload)
            markSavedFromCurrentDraft()
            NotificationCenter.default.post(name: .profileDidUpdate, object: nil)
            return true
        } catch {
            saveErrorMessage = NSLocalizedString("Profile.editSaveFailed", comment: "")
            return false
        }
    }

    private func applyFreshProfile(_ profile: ProfileScreen) {
        baselineProfile = profile
        syncDraftFromBaseline()
        clearFieldValidationErrors()
    }

    private func markSavedFromCurrentDraft() {
        let websiteStr = websiteValueForPutRequest()
        let websiteURL = URL(string: websiteStr) ?? baselineProfile.websiteURL
        let websiteTitle = websiteURL.host ?? baselineProfile.websiteTitle
        let avatarStr = avatarValueForPutRequest()
        let newAvatarURL = avatarStr.isEmpty ? nil : URL(string: avatarStr)

        baselineProfile = ProfileScreen(
            id: baselineProfile.id,
            name: normalized(name),
            description: normalized(description),
            websiteTitle: websiteTitle,
            websiteURL: websiteURL,
            avatarURL: newAvatarURL,
            likes: baselineProfile.likes,
            nfts: baselineProfile.nfts
        )
        avatarDeleted = false
        syncDraftFromBaseline()
    }

    private func syncDraftFromBaseline() {
        name = baselineProfile.name
        description = baselineProfile.description
        websiteText = baselineProfile.websiteURL.absoluteString
        manualAvatarURLString = baselineProfile.avatarURL?.absoluteString ?? ""
    }

    private func websiteValueForPutRequest() -> String {
        let trimmed = normalized(websiteText)
        return Self.resolveWebsiteURLString(trimmed) ?? baselineProfile.websiteURL.absoluteString
    }

    private func validateForSave() -> Bool {
        var isValid = true
        if normalized(name).isEmpty {
            nameValidationMessage = NSLocalizedString("Profile.editValidationNameEmpty", comment: "")
            isValid = false
        }
        let websiteTrimmed = normalized(websiteText)
        if websiteTrimmed.isEmpty {
            websiteValidationMessage = NSLocalizedString("Profile.editValidationWebsiteEmpty", comment: "")
            isValid = false
        } else if Self.resolveWebsiteURLString(websiteTrimmed) == nil {
            websiteValidationMessage = NSLocalizedString("Profile.editValidationWebsiteInvalid", comment: "")
            isValid = false
        }
        return isValid
    }

    private static func resolveWebsiteURLString(_ trimmed: String) -> String? {
        guard !trimmed.isEmpty else { return nil }
        if let url = URL(string: trimmed),
           let scheme = url.scheme?.lowercased(),
           scheme == "http" || scheme == "https",
           url.host != nil {
            return url.absoluteString
        }
        let withHTTPS = "https://\(trimmed)"
        if let url = URL(string: withHTTPS), url.host != nil {
            return url.absoluteString
        }
        return nil
    }

    private func normalized(_ raw: String) -> String {
        raw.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
