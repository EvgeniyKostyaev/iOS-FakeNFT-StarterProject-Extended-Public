//
//  ProfileLoadErrorView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 13.04.2026.
//

import SwiftUI

struct ProfileLoadErrorView: View {
    let message: String
    let onRepeat: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.dayNightBlack)
            Button(NSLocalizedString("Error.repeat", comment: ""), action: onRepeat)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.dayNightWhite.ignoresSafeArea())
    }
}

#Preview {
    ProfileLoadErrorView(message: "Preview error message") {}
}
