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
                ProfileHeaderBlock(profile: profile)
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)

                ProfileWebsiteLinkRow(profile: profile)
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }

            Section {
                NavigationLink {
                    MyNFTView(profile: profile)
                } label: {
                    ProfileMenuRowTitle(formatKey: "Profile.myNFTsFormat", count: profile.ownedNFTCount)
                }
                .navigationLinkIndicatorVisibility(.hidden)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

                NavigationLink {
                    FavoriteNFTView(profile: profile)
                } label: {
                    ProfileMenuRowTitle(formatKey: "Profile.favoritesFormat", count: profile.favoriteNFTCount)
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


private struct ProfileHeaderBlock: View {
    let profile: ProfileScreen

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .center, spacing: 16) {
                ProfileAvatarView(avatarURL: profile.avatarURL)

                Text(profile.name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.dayNightBlack)
            }

            Text(profile.description)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.dayNightBlack)
                .lineSpacing(4)
        }
    }
}

private struct ProfileWebsiteLinkRow: View {
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

private struct ProfileMenuRowTitle: View {
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
