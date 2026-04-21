//
//  ProfileMenuRowTitleView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 13.04.2026.
//

import SwiftUI

private enum ProfileMenuRowTitleViewTheme {
    static let previewListHorizontalInset: CGFloat = 16
}

struct ProfileMenuRowTitleView: View {
    let formatKey: String
    let count: Int

    var body: some View {
        HStack {
            Text(String(format: NSLocalizedString(formatKey, comment: ""), count))
                .font(.dsBodyBold)
                .foregroundStyle(.dayNightBlack)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.dsCaption1Semibold)
                .foregroundStyle(.dayNightBlack)
        }
    }
}

#Preview {
    List {
        ProfileMenuRowTitleView(formatKey: "Profile.myNFTsFormat", count: 112)
            .listRowInsets(
                EdgeInsets(
                    top: 0,
                    leading: ProfileMenuRowTitleViewTheme.previewListHorizontalInset,
                    bottom: 0,
                    trailing: ProfileMenuRowTitleViewTheme.previewListHorizontalInset
                )
            )
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        
        ProfileMenuRowTitleView(formatKey: "Profile.favoritesFormat", count: 11)
            .listRowInsets(
                EdgeInsets(
                    top: 0,
                    leading: ProfileMenuRowTitleViewTheme.previewListHorizontalInset,
                    bottom: 0,
                    trailing: ProfileMenuRowTitleViewTheme.previewListHorizontalInset
                )
            )
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
    .listStyle(.plain)
    .scrollContentBackground(.hidden)
}
