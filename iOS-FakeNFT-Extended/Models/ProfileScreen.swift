//
//  ProfileScreen.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 13.04.2026.
//

import Foundation

struct ProfileScreen: Equatable, Sendable {
    let id: String
    let name: String
    let description: String
    let websiteTitle: String
    let websiteURL: URL
    let avatarURL: URL?
    let likes: [String]
    let nfts: [String]

    var ownedNFTCount: Int { nfts.count }
    var favoriteNFTCount: Int { likes.count }

    static let profileScreenMock = ProfileScreen(
        id: "1",
        name: "Joaquin Phoenix",
        description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. "
            + "В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям..",
        websiteTitle: "Joaquin Phoenix.com",
        websiteURL: URL(string: "https://practicum.yandex.ru/ios-developer/?from=catalog")!,
        avatarURL: URL(string: "https://ui-avatars.com/api/?name=Joaquin+Phoenix&size=150"),
        likes: [
            "7773e33c-ec15-4230-a102-92426a3a6d5a",
            "ca34d35a-4507-47d9-9312-5ea7053994c0",
            "ca9130a1-8ec6-4a3a-9769-d6d7958b90e3"
        ],
        nfts: [
            "7773e33c-ec15-4230-a102-92426a3a6d5a",
            "ca34d35a-4507-47d9-9312-5ea7053994c0",
            "ca9130a1-8ec6-4a3a-9769-d6d7958b90e3"
        ]
    )
}
