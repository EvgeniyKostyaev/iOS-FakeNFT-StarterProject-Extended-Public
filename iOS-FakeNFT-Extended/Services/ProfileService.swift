//
//  ProfileService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 14.04.2026.
//

import Foundation

extension Notification.Name {
    static let profileDidUpdate = Notification.Name("profileDidUpdate")
}

protocol ProfileService {
    func loadProfile(userId: String) async throws -> ProfileScreen
    func updateProfile(_ payload: ProfileUpdatePayload) async throws
}

@MainActor
final class ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadProfile(userId: String) async throws -> ProfileScreen {
        let request = ProfileGetRequest(userId: userId)
        let dto: ProfileDTO = try await networkClient.send(request: request)

        return try ProfileScreen(dto: dto)
    }

    func updateProfile(_ payload: ProfileUpdatePayload) async throws {
        let request = ProfilePutRequest(payload: payload)
        _ = try await networkClient.send(request: request)
    }
}
