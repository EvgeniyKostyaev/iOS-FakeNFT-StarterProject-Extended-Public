//
//  MyNFTView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 14.04.2026.
//

import SwiftUI

struct MyNFTView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ServicesAssembly.self) private var services

    let profile: ProfileScreen

    @State private var viewModel = MyNFTViewModel()
    @State private var isSortDialogPresented = false

    private var myNFTsNavigationTitle: String? {
        if case .ready(let nfts) = viewModel.phase, !nfts.isEmpty {
            return NSLocalizedString("Profile.myNFTsNavTitle", comment: "")
        }
        return nil
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
                    nftList
                }
            case .failed(let message):
                loadFailedView(message: message)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.dayNightWhite.ignoresSafeArea())
        .task {
            await load()
        }
        .customNavigationBar(
            title: myNFTsNavigationTitle,
            action: { dismiss() },
            trailing: {
                if case .ready(let nfts) = viewModel.phase, !nfts.isEmpty {
                    sortToolbarButton
                }
            }
        )
        .confirmationDialog(
            NSLocalizedString("MyNFT.sortDialogTitle", comment: ""),
            isPresented: $isSortDialogPresented,
            titleVisibility: .visible
        ) {
            Button(NSLocalizedString("MyNFT.sortByPrice", comment: "")) {
                viewModel.setSortCriterion(.price)
            }
            Button(NSLocalizedString("MyNFT.sortByRating", comment: "")) {
                viewModel.setSortCriterion(.rating)
            }
            Button(NSLocalizedString("MyNFT.sortByName", comment: "")) {
                viewModel.setSortCriterion(.name)
            }
            Button(NSLocalizedString("MyNFT.sortClose", comment: ""), role: .cancel) {}
        }
    }

    private var sortToolbarButton: some View {
        Button {
            isSortDialogPresented = true
        } label: {
            Image(.sort)
                .renderingMode(.template)
                .foregroundStyle(.dayNightBlack)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(NSLocalizedString("MyNFT.sortAccessibility", comment: ""))
    }

    private var emptyState: some View {
        Text(NSLocalizedString("MyNFT.empty", comment: ""))
            .font(.dsBodyBold)
            .foregroundStyle(.dayNightBlack)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, MyNFTListRowViewLayout.listLeadingPadding)
    }

    private func loadFailedView(message: String) -> some View {
        LoadFailedView(
            message: message,
            retryAction: {
                Task {
                    await load()
                }
            },
            horizontalPadding: MyNFTListRowViewLayout.listLeadingPadding
        )
    }

    private var nftList: some View {
        List {
            ForEach(viewModel.listRowModels) { model in
                MyNFTListRowView(model: model)
                    .listRowInsets(
                        EdgeInsets(
                            top: MyNFTListRowViewLayout.listVerticalPadding,
                            leading: MyNFTListRowViewLayout.listLeadingPadding,
                            bottom: MyNFTListRowViewLayout.listVerticalPadding,
                            trailing: MyNFTListRowViewLayout.listTrailingPadding
                        )
                    )
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private func load() async {
        await viewModel.load(
            nftIds: profile.nfts,
            likedNFTIds: Set(profile.likes),
            nftService: services.nftService
        )
    }
}

#Preview("MyNFTView — loaded") {
    NavigationStack {
        MyNFTView(profile: .profileScreenMock)
    }
    .environment(ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl()))
}
