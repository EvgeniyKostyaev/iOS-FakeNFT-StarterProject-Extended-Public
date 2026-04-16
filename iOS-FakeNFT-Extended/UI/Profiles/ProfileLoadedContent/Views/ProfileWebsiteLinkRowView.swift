//
//  ProfileWebsiteLinkRowView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 13.04.2026.
//

import SwiftUI

struct ProfileWebsiteLinkRowView: View {
    let profile: ProfileScreen

    var body: some View {
        NavigationLink {
            WebViewRepresentable(url: profile.websiteURL)
        } label: {
            Text(profile.websiteTitle)
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.universalBlue)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationLinkIndicatorVisibility(.hidden)
    }
}

#Preview {
    NavigationStack {
        List {
            ProfileWebsiteLinkRowView(profile: .profileScreenMock)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}
