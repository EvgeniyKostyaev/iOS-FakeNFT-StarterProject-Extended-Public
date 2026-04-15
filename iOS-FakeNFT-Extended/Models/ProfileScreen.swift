//
//  ProfileScreen.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 13.04.2026.
//

import Foundation

struct ProfileScreen: Equatable {
    let id: String
    let name: String
    let description: String
    let websiteTitle: String
    let websiteURL: URL
    let avatarURL: URL?
    let ownedNFTCount: Int
    let favoriteNFTCount: Int
    
    static let profileScreenMock = ProfileScreen(
        id: "1",
        name: "Joaquin Phoenix",
        description: """
        Дизайнер из Казани, люблю цифровое искусство  и бейглы. В моей коллекции уже 100+ NFT,  и еще больше — на моём сайте. Открыт к коллаборациям..
        """,
        websiteTitle: "Joaquin Phoenix.com",
        websiteURL: URL(string: "https://practicum.yandex.ru/ios-developer/?from=catalog")!,
        avatarURL: URL(string: "https://picsum.photos/id/64/200/200"),
        ownedNFTCount: 112,
        favoriteNFTCount: 11
    )
    
}

