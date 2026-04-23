//
//  FavoriteNFTView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 14.04.2026.
//

import SwiftUI

struct FavoriteNFTView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ServicesAssembly.self) private var services

    let profile: ProfileScreen

    @State private var viewModel = FavoriteNFTViewModel()

    private var favoritesNavigationTitle: String? {
        if case .ready(let nfts) = viewModel.phase, !nfts.isEmpty {
            return NSLocalizedString("Profile.favoritesNavTitle", comment: "")
        }
        return nil
    }

    private var gridColumns: [GridItem] {
        [
            GridItem(.flexible(), spacing: FavoriteNFTGridLayout.columnSpacing),
            GridItem(.flexible(), spacing: FavoriteNFTGridLayout.columnSpacing)
        ]
    }

    var body: some View {
        Group {
            switch viewModel.phase {
            case .idle, .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .ready(let nfts):
                if nfts.isEmpty {
                    emptyState
                } else {
                    favoritesGrid
                }
            case .failed(let message):
                loadFailedView(message: message)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.dayNightWhite.ignoresSafeArea())
        .task(id: profile.likes) {
            await viewModel.load(likedNFTIds: profile.likes, nftService: services.nftService)
        }
        .alert(
            NSLocalizedString("Error.title", comment: ""),
            isPresented: Binding(
                get: { viewModel.removeFavoriteError != nil },
                set: { if !$0 { viewModel.clearRemoveFavoriteError() } }
            ),
            actions: {
                Button(NSLocalizedString("Error.ok", comment: ""), role: .cancel) {
                    viewModel.clearRemoveFavoriteError()
                }
            },
            message: {
                Text(viewModel.removeFavoriteError ?? "")
            }
        )
        .customNavigationBar(
            title: favoritesNavigationTitle,
            action: { dismiss() }
        )
    }

    private var favoritesGrid: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: FavoriteNFTGridLayout.rowSpacing) {
                ForEach(viewModel.cellModels) { model in
                    FavoriteNFTCellView(model: model) {
                        Task {
                            await viewModel.removeFromFavorites(
                                nftId: model.id,
                                profile: profile,
                                profileService: services.profileService
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, FavoriteNFTGridLayout.horizontalPadding)
            .padding(.top, 20)
        }
    }

    private var emptyState: some View {
        Text(NSLocalizedString("FavoriteNFT.empty", comment: ""))
            .font(.dsBodyBold)
            .foregroundStyle(.dayNightBlack)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, FavoriteNFTGridLayout.horizontalPadding)
    }

    private func loadFailedView(message: String) -> some View {
        VStack(spacing: 16) {
            Text(message)
                .font(.dsBodyRegular)
                .foregroundStyle(.dayNightBlack)
                .multilineTextAlignment(.center)
            Button(NSLocalizedString("Error.repeat", comment: "")) {
                Task {
                    await viewModel.load(likedNFTIds: profile.likes, nftService: services.nftService)
                }
            }
            .font(.dsBodySemibold)
        }
        .padding(.horizontal, FavoriteNFTGridLayout.horizontalPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NavigationStack {
        FavoriteNFTView(profile: .profileScreenMock)
    }
    .environment(ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl()))
}
