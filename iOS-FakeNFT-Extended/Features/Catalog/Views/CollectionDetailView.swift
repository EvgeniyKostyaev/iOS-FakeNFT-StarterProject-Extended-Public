//
//  CollectionDetailView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 21.04.2026.
//

import SwiftUI

private enum CollectionDetailViewTheme {
    static let gridSpacing: CGFloat = 8
    static let contentSpacing: CGFloat = 20
    static let gridVerticalSpacing: CGFloat = 24
    static let coverHeight: CGFloat = 310
    static let coverCornerRadius: CGFloat = 12
    static let horizontalPadding: CGFloat = 16
    static let topPadding: CGFloat = 8
    static let bottomPadding: CGFloat = 24
    static let headerSpacing: CGFloat = 8
    static let authorSpacing: CGFloat = 4
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
                coverView
                headerView

                LazyVGrid(
                    columns: gridItems,
                    alignment: .leading,
                    spacing: CollectionDetailViewTheme.gridVerticalSpacing
                ) {
                    ForEach(itemViewData.nftItems) { item in
                        NFTItemCellView(itemViewData: item)
                    }
                }
            }
            .padding(.bottom, CollectionDetailViewTheme.bottomPadding)
        }
        .background(Color(.dayNightWhite).ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var coverView: some View {
        Group {
            switch itemViewData.coverImageType {
            case .local(let imageResource):
                Image(imageResource)
                    .resizable()
                    .scaledToFill()
            case .remote(let url):
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Rectangle()
                        .fill(Color(.dayNightLightGray))
                        .overlay {
                            ProgressView()
                        }
                }
            }
        }
        .frame(height: CollectionDetailViewTheme.coverHeight)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: CollectionDetailViewTheme.coverCornerRadius))
        .padding(.horizontal, CollectionDetailViewTheme.horizontalPadding)
        .padding(.top, CollectionDetailViewTheme.topPadding)
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: CollectionDetailViewTheme.headerSpacing) {
            Text(itemViewData.title)
                .font(.dsHeadline1)
                .foregroundStyle(Color(.dayNightBlack))

            HStack(spacing: CollectionDetailViewTheme.authorSpacing) {
                Text("Collection.author")
                    .font(.dsBodyRegular)
                    .foregroundStyle(Color(.dayNightBlack))

                if let authorURL = itemViewData.authorURL {
                    Link(itemViewData.authorName, destination: authorURL)
                        .font(.dsBodyRegular)
                        .foregroundStyle(Color(.universalBlue))
                } else {
                    Text(itemViewData.authorName)
                        .font(.dsBodyRegular)
                        .foregroundStyle(Color(.universalBlue))
                }
            }

            Text(itemViewData.description)
                .font(.dsBodyRegular)
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
