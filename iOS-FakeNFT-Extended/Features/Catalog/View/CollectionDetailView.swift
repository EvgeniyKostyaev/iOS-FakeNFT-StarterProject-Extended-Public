//
//  CollectionDetailView.swift
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
}

struct CollectionDetailView: View {
    private let itemViewData: CollectionDetailViewData
    private let gridItems = [
        GridItem(.flexible(), spacing: CollectionDetailViewTheme.gridSpacing),
        GridItem(.flexible(), spacing: CollectionDetailViewTheme.gridSpacing),
        GridItem(.flexible(), spacing: CollectionDetailViewTheme.gridSpacing)
    ]
    
    init(itemViewData: CollectionDetailViewData) {
        self.itemViewData = itemViewData
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CollectionDetailViewTheme.contentSpacing) {
                CoverImage(imageSourceType: itemViewData.coverImageType)
                    .frame(height: CollectionDetailViewTheme.coverImageHeight)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: CollectionDetailViewTheme.coverCornerRadius))
                
                headerView
                
                LazyVGrid(
                    columns: gridItems,
                    alignment: .center,
                    spacing: CollectionDetailViewTheme.gridVerticalSpacing
                ) {
                    ForEach(itemViewData.nftItems) { item in
                        NavigationLink(value: item) {
                            NFTItemCellView(itemViewData: item)
                        }
                    }
                }
                .padding(.horizontal, CollectionDetailViewTheme.gridHorizontalPadding)
            }
            .padding(.bottom, CollectionDetailViewTheme.bottomPadding)
        }
        .background(Color(.dayNightWhite).ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
        .navigationDestination(for: CollectionDetailViewData.self) { item in
            if let authorURL = item.authorURL {
                WebViewRepresentable(url: authorURL)
            }
        }
        .navigationDestination(for: CollectionNFTViewData.self) { item in
            NftDetailBridgeView(nftId: item.id)
        }
    }
    
    @ViewBuilder
    private var headerView: some View {
        VStack(alignment: .leading, spacing: CollectionDetailViewTheme.headerSpacing) {
            Text(itemViewData.title)
                .font(.dsHeadline3)
                .foregroundStyle(Color(.dayNightBlack))
                .padding(.bottom, CollectionDetailViewTheme.headerTextBottomPadding)
            
            HStack(spacing: CollectionDetailViewTheme.authorSpacing) {
                Text("Collection.author")
                    .font(.dsCaption2)
                    .foregroundStyle(Color(.dayNightBlack))
                
                NavigationLink(itemViewData.authorName, value: itemViewData)
                    .font(.dsCaption1)
                    .foregroundStyle(Color(.universalBlue))
            }
            
            Text(itemViewData.description)
                .font(.dsCaption2)
                .foregroundStyle(Color(.dayNightBlack))
        }
        .padding(.horizontal, CollectionDetailViewTheme.horizontalPadding)
    }
}

#Preview {
    NavigationStack {
        CollectionDetailView(
            itemViewData: .mock(
                from: CollectionViewData(
                    id: "1",
                    title: "Peach",
                    coverImageType: .local(.collectionPeach),
                    nftCount: 11
                )
            )
        )
    }
}
