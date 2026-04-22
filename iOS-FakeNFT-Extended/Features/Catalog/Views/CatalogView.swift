//
//  CatalogView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 21.04.2026.
//

import SwiftUI

struct CatalogView: View {
    var body: some View {
        NavigationStack {
            List {
                Text("TEST1")
                Text("TEST2")
                Text("TEST3")
                Text("TEST4")
                Text("TEST5")
                Text("TEST6")
                Text("TEST7")
            }
        }
    }
}

#Preview {
    CatalogView()
}
