//
//  ProfileLoadedContentView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 13.04.2026.
//

import SwiftUI

struct ProfileLoadedContentView: View {
    @Environment(ServicesAssembly.self) private var services

    let profile: ProfileScreen

    @State private var navigationTarget: ProfileNavigationTarget?

    var body: some View {
        List {
            Section {
                ProfileHeaderBlockView(profile: profile)
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)

                Button {
                    navigationTarget = .website
                } label: {
                    ProfileWebsiteLinkRowView(profile: profile)
                }
                .buttonStyle(.plain)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }

            Section {
                Button {
                    navigationTarget = .myNFT
                } label: {
                    ProfileMenuRowTitleView(formatKey: "Profile.myNFTsFormat", count: profile.ownedNFTCount)
                }
                .buttonStyle(.plain)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

                Button {
                    navigationTarget = .favorites
                } label: {
                    ProfileMenuRowTitleView(formatKey: "Profile.favoritesFormat", count: profile.favoriteNFTCount)
                }
                .buttonStyle(.plain)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .listSectionSpacing(20)
        .scrollContentBackground(.hidden)
        .background(Color.dayNightWhite.ignoresSafeArea())
        .navigationDestination(item: $navigationTarget) { target in
            switch target {
            case .website:
                WebViewRepresentable(url: profile.websiteURL)
            case .myNFT:
                MyNFTView(profile: profile)
            case .favorites:
                FavoriteNFTView(profile: profile)
            }
        }
        .safeAreaInset(edge: .top) {
            HStack {
                Spacer()
                NavigationLink {
                    ProfileEditView(profile: profile, profileService: services.profileService)
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

private enum ProfileNavigationTarget: Hashable {
    case website
    case myNFT
    case favorites
}

#Preview {
    NavigationStack {
        ProfileLoadedContentView(profile: .profileScreenMock)
    }
    .environment(ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl()))
}
