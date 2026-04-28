//
//  CatalogView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 21.04.2026.
//

import SwiftUI

// MARK: - Theme
private enum CatalogViewTheme {
    static let scaleEffect: CGFloat = 1.5
    static let backgroundOpacity: CGFloat = 0.8
}

// MARK: - View
struct CatalogView: View {
    
    // MARK: - State
    @Environment(ServicesAssembly.self) private var services
    @State private var viewModel = CatalogViewModel()
    @State private var showConfirmationDialog: Bool = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            contentList
                .overlay { loadingView }
                .toolbar { toolbarContent }
                .navigationTitle("Catalog.title")
                .navigationBarTitleDisplayMode(.inline)
                .navigationLinkIndicatorVisibility(.hidden)
                .navigationDestination(for: CollectionViewData.self, destination: { item in
                    if let collection = viewModel.collection(id: item.id) {
                        CollectionDetailView(collection: collection)
                            .toolbar(.hidden, for: .tabBar)
                    }
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
    private var contentList: some View {
        List(viewModel.collections) { item in
            NavigationLink(value: item) {
                CollectionCellView(itemViewData: item)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .task {
            await viewModel.loadCollections(catalogService: services.catalogService)
        }
    }
    
    @ViewBuilder
    private var loadingView: some View {
        if viewModel.isLoading {
            ProgressView()
                .scaleEffect(CatalogViewTheme.scaleEffect)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground).opacity(CatalogViewTheme.backgroundOpacity))
        }
    }
    
    // MARK: - Toolbar
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showConfirmationDialog = true
            } label: {
                Image(.sort)
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
