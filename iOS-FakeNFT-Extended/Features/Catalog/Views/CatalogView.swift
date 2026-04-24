//
//  CatalogView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 21.04.2026.
//

import SwiftUI

private enum CatalogViewTheme {
    static let scaleEffect: CGFloat = 1.5
    static let backgroundOpacity: CGFloat = 0.8
}

struct CatalogView: View {
    @State private var viewModel = CatalogViewModel()
    @State private var showConfirmationDialog: Bool = false
    
    var body: some View {
        NavigationStack {
            List(CollectionViewData.mock()) { item in
                NavigationLink(value: item) {
                    CollectionCellView(itemViewData: item)
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(CatalogViewTheme.scaleEffect)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemBackground).opacity(CatalogViewTheme.backgroundOpacity))
                }
            }
            .toolbar {
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
            .navigationTitle("Catalog.title")
            .navigationBarTitleDisplayMode(.inline)
            .navigationLinkIndicatorVisibility(.hidden)
            .navigationDestination(for: CollectionViewData.self, destination: { item in
                CollectionDetailView(itemViewData: .mock(from: item))
                    .toolbar(.hidden, for: .tabBar)
            })
            .confirmationDialog("Catalog.sorting", isPresented: $showConfirmationDialog) {
                Button("Catalog.sortingByName") { viewModel.sortByName() }
                Button("Catalog.sortingByCountNFT") { viewModel.sortByCountNFT() }
                Button("Common.close", role: .cancel) { }
            } message: {
                Text("Catalog.sorting")
            }
        }
    }
}

#Preview {
    CatalogView()
}
