//
//  ProfileLoadErrorViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 21.04.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class ProfileLoadErrorViewModel {

    let message: String

    private let onRepeat: () -> Void

    init(message: String, onRepeat: @escaping () -> Void) {
        self.message = message
        self.onRepeat = onRepeat
    }

    func repeatTapped() {
        onRepeat()
    }
}
