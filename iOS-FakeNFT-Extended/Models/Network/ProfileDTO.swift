//
//  ProfileDTO.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 14.04.2026.
//

import Foundation

struct ProfileDTO: Decodable, Sendable {
    let id: String
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
}

enum ProfileMappingError: Error {
    case invalidWebsiteURL
}

extension ProfileScreen {
    init(dto: ProfileDTO) throws {
        guard let websiteURL = URL(string: dto.website) else {
            throw ProfileMappingError.invalidWebsiteURL
        }
        let websiteTitle = URL(string: dto.website)?.host ?? dto.website
        self.init(
            name: dto.name,
            description: dto.description,
            websiteTitle: websiteTitle,
            websiteURL: websiteURL,
            avatarURL: URL(string: dto.avatar),
            ownedNFTCount: dto.nfts.count,
            favoriteNFTCount: dto.likes.count
        )
    }
}
