import Foundation
import Observation

@MainActor
@Observable
final class ProfileEditViewModel {

    // MARK: - Черновик полей (редактируемые до «Сохранить»)

    var name: String
    var description: String
    /// Полный URL сайта для редактирования (на экране профиля показывается `websiteTitle`).
    var websiteText: String

    /// Ссылка на аватар (строка для API `avatar` и превью).
    var manualAvatarURLString: String

    /// Пользователь удалил аватар (для PUT передать пустую строку — по контракту API).
    var avatarDeleted: Bool

    // MARK: - Сохранение и подгрузка формы

    private(set) var isSaving = false
    private(set) var saveErrorMessage: String?

    /// Ошибки валидации полей (показываются под соответствующими полями).
    private(set) var nameValidationMessage: String?
    private(set) var websiteValidationMessage: String?

    private let profileService: ProfileService
    private let profileId: String

    private var canonicalWebsiteURL: URL
    private var preservedLikes: [String]
    private var preservedNfts: [String]

    private var initialName: String
    private var initialDescription: String
    private var initialWebsiteText: String
    private var initialAvatarURLString: String
    private var initialProfileAvatarURL: URL?

    init(profile: ProfileScreen, profileService: ProfileService) {
        self.profileService = profileService
        self.profileId = profile.id
        self.canonicalWebsiteURL = profile.websiteURL
        self.preservedLikes = profile.likes
        self.preservedNfts = profile.nfts

        let name = profile.name
        let description = profile.description
        let websiteURLString = profile.websiteURL.absoluteString
        let avatarURL = profile.avatarURL?.absoluteString ?? ""

        self.name = name
        self.description = description
        self.websiteText = websiteURLString
        self.manualAvatarURLString = avatarURL

        self.initialName = name
        self.initialDescription = description
        self.initialWebsiteText = websiteURLString
        self.initialAvatarURLString = avatarURL
        self.initialProfileAvatarURL = profile.avatarURL

        self.avatarDeleted = false
    }

    /// Подставляет в форму актуальные данные с сервера (при ошибке остаётся переданный при входе профиль).
    func loadFormDataFromServer() async {
        do {
            let fresh = try await profileService.loadProfile(userId: profileId)
            applyFreshProfile(fresh)
        } catch {
            // оставляем черновик из init(profile:)
        }
    }

    /// URL для превью: введённая ссылка или исходный аватар профиля.
    var avatarPreviewURL: URL? {
        if avatarDeleted { return nil }
        let trimmed = normalized(manualAvatarURLString)
        if let url = URL(string: trimmed), !trimmed.isEmpty {
            return url
        }
        return initialProfileAvatarURL
    }

    var hasUnsavedTextChanges: Bool {
        name != initialName
            || description != initialDescription
            || websiteText != initialWebsiteText
    }

    var hasUnsavedAvatarChanges: Bool {
        avatarDeleted
            || normalized(manualAvatarURLString) != normalized(initialAvatarURLString)
    }

    /// Значение поля `avatar` для тела PUT (только строка ссылки).
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

    func markSavedFromCurrentDraft() {
        initialName = name
        initialDescription = description
        initialWebsiteText = websiteText
        initialAvatarURLString = normalized(manualAvatarURLString)
        avatarDeleted = false
    }

    /// Сохраняет черновик на сервер. При успехе синхронизирует baseline и шлёт `profileDidUpdate`.
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
                userId: profileId,
                name: normalized(name),
                description: normalized(description),
                website: websiteValueForPutRequest(),
                avatar: avatarValueForPutRequest(),
                likes: preservedLikes,
                nfts: preservedNfts
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
        canonicalWebsiteURL = profile.websiteURL
        preservedLikes = profile.likes
        preservedNfts = profile.nfts

        name = profile.name
        description = profile.description
        websiteText = profile.websiteURL.absoluteString
        manualAvatarURLString = profile.avatarURL?.absoluteString ?? ""
        avatarDeleted = false
        initialProfileAvatarURL = profile.avatarURL

        initialName = name
        initialDescription = description
        initialWebsiteText = websiteText
        initialAvatarURLString = normalized(manualAvatarURLString)
        clearFieldValidationErrors()
    }

    /// Для API: нормализованный URL из поля (после успешной валидации).
    private func websiteValueForPutRequest() -> String {
        let trimmed = normalized(websiteText)
        return Self.resolveWebsiteURLString(trimmed) ?? canonicalWebsiteURL.absoluteString
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

    /// Нормализует строку к абсолютному http(s)-URL или возвращает `nil`.
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
