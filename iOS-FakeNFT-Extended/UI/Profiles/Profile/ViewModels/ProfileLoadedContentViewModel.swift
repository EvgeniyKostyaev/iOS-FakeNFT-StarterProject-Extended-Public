//
//  ProfileLoadedContentViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 21.04.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class ProfileLoadedContentViewModel {

    var profile: ProfileScreen
    let profileService: ProfileServiceProtocol

    init(profile: ProfileScreen, profileService: ProfileServiceProtocol) {
        self.profile = profile
        self.profileService = profileService
    }
}
