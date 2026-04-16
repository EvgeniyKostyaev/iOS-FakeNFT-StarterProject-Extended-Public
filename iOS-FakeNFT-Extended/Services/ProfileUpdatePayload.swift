//
//  ProfileUpdatePayload.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 14.04.2026.
//

import Foundation

struct ProfileUpdatePayload: Sendable {
    let userId: String
    let name: String
    let description: String
    let website: String
    let avatar: String
    let likes: [String]
    let nfts: [String]
}
