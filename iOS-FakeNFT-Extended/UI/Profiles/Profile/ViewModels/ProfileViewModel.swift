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

    private(set) var loadedContentViewModel: ProfileLoadedContentViewModel?

    func loadProfile(profileService: ProfileServiceProtocol, showsLoadingIndicator: Bool = true) async {
        if showsLoadingIndicator, case .loaded = state, loadedContentViewModel != nil {
            return
        }

        if showsLoadingIndicator {
            if case .loading = state { return }
            state = .loading
            loadedContentViewModel = nil
        } else {
            guard case .loaded = state else { return }
        }

        do {
            let profile = try await profileService.loadProfile(userId: ProfileAPIPath.gatewayProfilePathSegment)
            if let vm = loadedContentViewModel, vm.profile.id == profile.id {
                vm.profile = profile
            } else {
                loadedContentViewModel = ProfileLoadedContentViewModel(
                    profile: profile,
                    profileService: profileService
                )
            }
            state = .loaded(profile)
        } catch let error as NetworkClientError {
            if showsLoadingIndicator {
                loadedContentViewModel = nil
                state = .failed(message(for: error))
            }
        } catch {
            if showsLoadingIndicator {
                loadedContentViewModel = nil
                state = .failed(NSLocalizedString("Profile.loadFailed", comment: ""))
            }
        }
    }

    func retryLoading(profileService: ProfileServiceProtocol) {
        Task { await loadProfile(profileService: profileService) }
    }

    private func message(for error: NetworkClientError) -> String {
        switch error {
        case .httpStatusCode, .urlRequestError, .urlSessionError, .parsingError, .incorrectRequest:
            return NSLocalizedString("Error.network", comment: "")
        }
    }
}
