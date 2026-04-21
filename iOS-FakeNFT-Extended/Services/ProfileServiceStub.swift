//
//  ProfileServiceStub.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 14.04.2026.
//

import Foundation

final class ProfileServiceStub: ProfileService {
    var updateProfileError: Error?

    func loadProfile(userId: String) async throws -> ProfileScreen {
        _ = userId
        return .profileScreenMock
    }

    func updateProfile(_ payload: ProfileUpdatePayload) async throws {
        _ = payload
        if let updateProfileError {
            throw updateProfileError
        }
    }
}
