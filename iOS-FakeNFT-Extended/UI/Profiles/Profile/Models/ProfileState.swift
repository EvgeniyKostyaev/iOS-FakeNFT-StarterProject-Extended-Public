//
//  ProfileState.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 13.04.2026.
//

import Foundation

enum ProfileState: Equatable {
    case idle
    case loading
    case loaded(ProfileScreen)
    case failed(String)
}
