//
//  CatalogView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 21.04.2026.
//

import SwiftUI

// MARK: - Theme
struct CatalogView: View {
    
    // MARK: - State
    @Environment(ServicesAssembly.self) private var services
    @State private var viewModel = CatalogViewModel()
    @State private var showConfirmationDialog: Bool = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            content
                .toolbar { toolbarContent }
                .navigationTitle("Catalog.title")
                .navigationBarTitleDisplayMode(.inline)
                .navigationLinkIndicatorVisibility(.hidden)
                .navigationDestination(for: Collection.self, destination: { collection in
                    CollectionDetailsView(collection: collection)
                        .toolbar(.hidden, for: .tabBar)
                })
                .confirmationDialog(
                    "Catalog.sorting",
                    isPresented: $showConfirmationDialog,
                    actions: sortingActions,
                    message: { Text("Catalog.sorting") }
                )
        }
    }
    
    // MARK: - Subviews
    @ViewBuilder
    private var content: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                LoadInProgressView()
            case .ready(let collections):
                List(collections) { collection in
                    NavigationLink(value: collection) {
                        CollectionCellView(itemViewData: collection.toViewData())
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .refreshable {
                    await viewModel.reloadCollections(catalogService: services.catalogService)
                }
            case .failed(let message):
                loadFailedView(message: message)
            }
        }
        .task {
            await viewModel.loadCollectionsIfNeeded(catalogService: services.catalogService)
        }
    }
    
    // MARK: - Toolbar
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        if !viewModel.collections.isEmpty {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showConfirmationDialog = true
                } label: {
                    Image(.sort)
                }
            }
        }
        ToolbarItem(placement: .principal) {
            Text(String())
        }
    }
    
    // MARK: - Dialog
    @ViewBuilder
    private func sortingActions() -> some View {
        Button("Catalog.sortingByName") {
            viewModel.sortByName()
        }
        Button("Catalog.sortingByCountNFT") {
            viewModel.sortByCountNFT()
        }
        Button("Common.close", role: .cancel) { }
    }

    private func loadFailedView(message: String) -> some View {
        LoadFailedView(message: message) {
            Task {
                await viewModel.reloadCollections(catalogService: services.catalogService)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    CatalogView()
        .environment(
            ServicesAssembly(
                networkClient: DefaultNetworkClient(),
            )
        )
}
