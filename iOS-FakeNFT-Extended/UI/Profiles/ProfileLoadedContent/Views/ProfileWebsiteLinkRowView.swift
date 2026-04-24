//
//  ProfileWebsiteLinkRowView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 13.04.2026.
//

import SwiftUI

private enum ProfileWebsiteLinkRowViewTheme {
    static let previewListHorizontalInset: CGFloat = 16
}

struct ProfileWebsiteLinkRowView: View {
    let profile: ProfileScreen

    var body: some View {
        Text(profile.websiteTitle)
            .font(.dsCaption1)
            .foregroundStyle(.universalBlue)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    NavigationStack {
        List {
            ProfileWebsiteLinkRowView(profile: .profileScreenMock)
                .listRowInsets(
                    EdgeInsets(
                        top: 0,
                        leading: ProfileWebsiteLinkRowViewTheme.previewListHorizontalInset,
                        bottom: 0,
                        trailing: ProfileWebsiteLinkRowViewTheme.previewListHorizontalInset
                    )
                )
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}
