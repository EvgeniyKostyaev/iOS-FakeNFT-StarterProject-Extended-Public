//
//  ProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 13.04.2026.
//

import SwiftUI

struct ProfileView: View {
    @Environment(ServicesAssembly.self) private var services
    @State private var viewModel = ProfileViewModel()

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                ProfileLoadingView()
            case .loaded(let profile):
                ProfileLoadedContentView(profile: profile)
            case .failed(let message):
                ProfileLoadErrorView(message: message) {
                    viewModel.retryLoading(profileService: services.profileService)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadProfile(profileService: services.profileService)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
    .environment(ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl()))
}
