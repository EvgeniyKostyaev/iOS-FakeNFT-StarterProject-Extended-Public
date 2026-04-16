//
//  ProfileViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 14.04.2026.
//

import Foundation

@MainActor
@Observable
final class ProfileViewModel {

    private(set) var state: ProfileState = .idle

    func loadProfile(profileService: ProfileService) async {
        if case .loading = state { return }
        state = .loading
        do {
            let profile = try await profileService.loadProfile()
            state = .loaded(profile)
        } catch let error as NetworkClientError {
            state = .failed(message(for: error))
        } catch {
            state = .failed(NSLocalizedString("Profile.loadFailed", comment: ""))
        }
    }

    func retryLoading(profileService: ProfileService) {
        Task { await loadProfile(profileService: profileService) }
    }

    private func message(for error: NetworkClientError) -> String {
        switch error {
        case .httpStatusCode, .urlRequestError, .urlSessionError, .parsingError, .incorrectRequest:
            return NSLocalizedString("Error.network", comment: "")
        }
    }
}
