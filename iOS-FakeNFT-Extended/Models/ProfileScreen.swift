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
            "a10d016c-92a9-48c2-8086-d376d5cbe201",
            "b20d016c-92a9-48c2-8086-d376d5cbe202"
        ],
        nfts: [
            "c30d016c-92a9-48c2-8086-d376d5cbe203",
            "d40d016c-92a9-48c2-8086-d376d5cbe204",
            "e50d016c-92a9-48c2-8086-d376d5cbe205"
        ]
    )
}
