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
    let profileService: ProfileService

    init(profile: ProfileScreen, profileService: ProfileService) {
        self.profile = profile
        self.profileService = profileService
    }
}
