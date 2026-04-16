//
//  ProfileLoadedContentView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 13.04.2026.
//

import SwiftUI

struct ProfileLoadedContentView: View {
    let profile: ProfileScreen

    var body: some View {
        List {
            Section {
                ProfileHeaderBlockView(profile: profile)
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)

                ProfileWebsiteLinkRowView(profile: profile)
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }

            Section {
                NavigationLink {
                    MyNFTView(profile: profile)
                } label: {
                    ProfileMenuRowTitleView(formatKey: "Profile.myNFTsFormat", count: profile.ownedNFTCount)
                }
                .navigationLinkIndicatorVisibility(.hidden)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

                NavigationLink {
                    FavoriteNFTView(profile: profile)
                } label: {
                    ProfileMenuRowTitleView(formatKey: "Profile.favoritesFormat", count: profile.favoriteNFTCount)
                }
                .navigationLinkIndicatorVisibility(.hidden)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .listSectionSpacing(20)
        .scrollContentBackground(.hidden)
        .background(Color.dayNightWhite.ignoresSafeArea())
        .safeAreaInset(edge: .top) {
            HStack {
                Spacer()
                NavigationLink {
                    ProfileEditView(profile: profile)
                } label: {
                    Image(.edit)
                        .renderingMode(.template)
                        .foregroundStyle(.dayNightBlack)
                }
                .buttonStyle(.plain)
                .padding(.trailing, 8)
            }
            .padding(.top, 8)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileLoadedContentView(profile: .profileScreenMock)
    }
}
