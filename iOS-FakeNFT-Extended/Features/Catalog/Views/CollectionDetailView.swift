//
//  CollectionDetailView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 21.04.2026.
//

import SwiftUI

struct CollectionDetailView: View {
    private let itemViewData: CollectionDetailViewData
    private let gridItems = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]

    init(itemViewData: CollectionDetailViewData) {
        self.itemViewData = itemViewData
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                coverView
                headerView

                LazyVGrid(columns: gridItems, alignment: .leading, spacing: 24) {
                    ForEach(itemViewData.nftItems) { item in
                        NFTItemCellView(itemViewData: item)
                    }
                }
            }
            .padding(.bottom, 24)
        }
        .background(Color.dsDayNightWhite.ignoresSafeArea())
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
                        .fill(Color.dsDayNightLightGray)
                        .overlay {
                            ProgressView()
                        }
                }
            }
        }
        .frame(height: 310)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(itemViewData.title)
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(Color.dsDayNightBlack)

            HStack(spacing: 4) {
                Text("Collection.author")
                    .font(.dsBodyRegular)
                    .foregroundStyle(Color.dsDayNightBlack)

                if let authorURL = itemViewData.authorURL {
                    Link(itemViewData.authorName, destination: authorURL)
                        .font(.dsBodyRegular)
                        .foregroundStyle(Color.dsUniversalBlue)
                } else {
                    Text(itemViewData.authorName)
                        .font(.dsBodyRegular)
                        .foregroundStyle(Color.dsUniversalBlue)
                }
            }

            Text(itemViewData.description)
                .font(.dsBodyRegular)
                .foregroundStyle(Color.dsDayNightBlack)
        }
        .padding(.horizontal, 16)
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
