//
//  ProfileService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 14.04.2026.
//

import Foundation

protocol ProfileService {
    func loadProfile() async throws -> ProfileScreen
}

@MainActor
final class ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    func loadProfile() async throws -> ProfileScreen {
        let request = ProfileGetRequest()
        let dto: ProfileDTO = try await networkClient.send(request: request)
        return try ProfileScreen(dto: dto)
    }
}
