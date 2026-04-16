//
//  ProfileMenuRowTitleView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 13.04.2026.
//

import SwiftUI

struct ProfileMenuRowTitleView: View {
    let formatKey: String
    let count: Int

    var body: some View {
        HStack {
            Text(String(format: NSLocalizedString(formatKey, comment: ""), count))
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.dayNightBlack)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.dayNightBlack)
        }
    }
}

#Preview {
    List {
        ProfileMenuRowTitleView(formatKey: "Profile.myNFTsFormat", count: 112)
            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        
        ProfileMenuRowTitleView(formatKey: "Profile.favoritesFormat", count: 11)
            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
    .listStyle(.plain)
    .scrollContentBackground(.hidden)
}
