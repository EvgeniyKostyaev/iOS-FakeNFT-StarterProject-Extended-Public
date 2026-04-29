//
//  CollectionDetailsView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 21.04.2026.
//

import SwiftUI

private enum CollectionDetailViewTheme {
    static let gridSpacing: CGFloat = 8
    static let contentSpacing: CGFloat = 24
    static let gridVerticalSpacing: CGFloat = 28
    static let coverImageHeight: CGFloat = 310
    static let coverCornerRadius: CGFloat = 12
    static let horizontalPadding: CGFloat = 16
    static let gridHorizontalPadding: CGFloat = 12
    static let bottomPadding: CGFloat = 24
    static let headerSpacing: CGFloat = 8
    static let authorSpacing: CGFloat = 4
    static let headerTextBottomPadding: CGFloat = 6
    static let loadingScale: CGFloat = 1.2
}

struct CollectionDetailsView: View {
    @Environment(ServicesAssembly.self) private var services
    @State private var viewModel: CollectionDetailsViewModel

    private let gridItems = [
        GridItem(.flexible(), spacing: CollectionDetailViewTheme.gridSpacing),
        GridItem(.flexible(), spacing: CollectionDetailViewTheme.gridSpacing),
        GridItem(.flexible(), spacing: CollectionDetailViewTheme.gridSpacing)
    ]
    
    init(collection: Collection) {
        _viewModel = State(wrappedValue: CollectionDetailsViewModel(collection: collection))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CollectionDetailViewTheme.contentSpacing) {
                NFTImageView(imageSourceType: .remote(viewModel.collection.cover))
                    .frame(height: CollectionDetailViewTheme.coverImageHeight)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: CollectionDetailViewTheme.coverCornerRadius))
                
                headerView
                
                Group {
                    switch viewModel.state {
                    case .idle, .loading:
                        ProgressView()
                            .scaleEffect(CollectionDetailViewTheme.loadingScale)
                            .frame(maxWidth: .infinity)
                    case .ready:
                        LazyVGrid(
                            columns: gridItems,
                            alignment: .center,
                            spacing: CollectionDetailViewTheme.gridVerticalSpacing
                        ) {
                            ForEach(viewModel.nfts) { item in
                                NavigationLink(value: item) {
                                    NFTItemCellView(
                                        itemViewData: item,
                                        onFavoriteTap: {
                                            Task {
                                                await viewModel.toggleFavorite(
                                                    nftId: item.nftId,
                                                    profileService: services.profileService
                                                )
                                            }
                                        }
                                    )
                                }
                            }
                        }
                    case .failed(let message):
                        loadFailedView(message: message)
                    }
                }
                .padding(.horizontal, CollectionDetailViewTheme.gridHorizontalPadding)
            }
            .padding(.bottom, CollectionDetailViewTheme.bottomPadding)
        }
        .background(Color(.dayNightWhite).ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
        .task(id: viewModel.collection.id) {
            await viewModel.loadNFTs(
                nftService: services.nftService,
                profileService: services.profileService
            )
        }
        .navigationDestination(for: URL.self) { url in
            WebViewRepresentable(url: url)
        }
        .navigationDestination(for: CollectionNFTViewData.self) { item in
            NftDetailBridgeView(nftId: item.nftId)
        }
    }
    
    @ViewBuilder
    private var headerView: some View {
        VStack(alignment: .leading, spacing: CollectionDetailViewTheme.headerSpacing) {
            Text(viewModel.collection.name)
                .font(.dsHeadline3)
                .foregroundStyle(Color(.dayNightBlack))
                .padding(.bottom, CollectionDetailViewTheme.headerTextBottomPadding)
            
            HStack(spacing: CollectionDetailViewTheme.authorSpacing) {
                Text("Collection.author")
                    .font(.dsCaption2)
                    .foregroundStyle(Color(.dayNightBlack))
                
                if let websiteURL = viewModel.collection.websiteURL {
                    NavigationLink(viewModel.collection.author, value: websiteURL)
                        .font(.dsCaption1)
                        .foregroundStyle(Color(.universalBlue))
                } else {
                    Text(viewModel.collection.author)
                        .font(.dsCaption1)
                        .foregroundStyle(Color(.dayNightBlack))
                }
            }
            
            Text(viewModel.collection.description)
                .font(.dsCaption2)
                .foregroundStyle(Color(.dayNightBlack))
        }
        .padding(.horizontal, CollectionDetailViewTheme.horizontalPadding)
    }

    private func loadFailedView(message: String) -> some View {
        LoadFailedView(
            message: message,
            retryAction: {
                Task {
                    await viewModel.loadNFTs(
                        nftService: services.nftService,
                        profileService: services.profileService
                    )
                }
            },
            horizontalPadding: CollectionDetailViewTheme.gridHorizontalPadding,
            expandsVertically: false
        )
    }
}

#Preview {
    NavigationStack {
        CollectionDetailsView(
            collection: Collection(
                id: "1",
                name: "Peach",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/Collections/1.png")!,
                nfts: [],
                author: "John Doe",
                description: "Collection description",
                websiteURL: URL(string: "https://practicum.yandex.ru"),
                createdAt: nil
            )
        )
    }
}
