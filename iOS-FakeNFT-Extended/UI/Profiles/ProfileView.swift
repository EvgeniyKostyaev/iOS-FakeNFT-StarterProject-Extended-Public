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
            case .loaded:
                if let contentViewModel = viewModel.loadedContentViewModel {
                    ProfileLoadedContentView(viewModel: contentViewModel)
                } else {
                    ProfileLoadingView()
                }
            case .failed(let message):
                LoadFailedView(message: message) {
                    Task {
                        viewModel.retryLoading(profileService: services.profileService)
                    }
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(String())
            }
        }
        .onAppear {
            Task {
                await viewModel.loadProfile(profileService: services.profileService)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .profileDidUpdate)) { _ in
            Task {
                await viewModel.loadProfile(
                    profileService: services.profileService,
                    showsLoadingIndicator: false
                )
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
