//
//  ProfileLoadedContentView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 13.04.2026.
//

import SwiftUI

private enum ProfileLoadedContentViewTheme {
    static let listHorizontalInset: CGFloat = 16
    static var listRowInsets: EdgeInsets {
        EdgeInsets(top: 0, leading: listHorizontalInset, bottom: 0, trailing: listHorizontalInset)
    }

    static let listSectionSpacing: CGFloat = 20
    static let editButtonTrailingPadding: CGFloat = 8
    static let editButtonTopPadding: CGFloat = 8
}

struct ProfileLoadedContentView: View {
    @Bindable var viewModel: ProfileLoadedContentViewModel

    @State private var stackDestination: ProfileStackDestination?
    @State private var isWebsiteFullScreenPresented = false
    @State private var profileEditPresentationID: UUID?

    var body: some View {
        List {
            Section {
                ProfileHeaderBlockView(profile: viewModel.profile)
                    .listRowInsets(ProfileLoadedContentViewTheme.listRowInsets)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)

                Button {
                    isWebsiteFullScreenPresented = true
                } label: {
                    ProfileWebsiteLinkRowView(profile: viewModel.profile)
                }
                .buttonStyle(.plain)
                .listRowInsets(ProfileLoadedContentViewTheme.listRowInsets)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }

            Section {
                Button {
                    stackDestination = .myNFT
                } label: {
                    ProfileMenuRowTitleView(formatKey: "Profile.myNFTsFormat", count: viewModel.profile.ownedNFTCount)
                }
                .buttonStyle(.plain)
                .listRowInsets(ProfileLoadedContentViewTheme.listRowInsets)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

                Button {
                    stackDestination = .favorites
                } label: {
                    ProfileMenuRowTitleView(formatKey: "Profile.favoritesFormat", count: viewModel.profile.favoriteNFTCount)
                }
                .buttonStyle(.plain)
                .listRowInsets(ProfileLoadedContentViewTheme.listRowInsets)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .listSectionSpacing(ProfileLoadedContentViewTheme.listSectionSpacing)
        .scrollContentBackground(.hidden)
        .background(Color.dayNightWhite.ignoresSafeArea())
        .navigationDestination(item: $stackDestination) { target in
            switch target {
            case .myNFT:
                MyNFTView(profile: viewModel.profile)
            case .favorites:
                FavoriteNFTView(profile: viewModel.profile)
            }
        }
        .navigationDestination(item: $profileEditPresentationID) { _ in
            ProfileEditView(profile: viewModel.profile, profileService: viewModel.profileService)
                .onDisappear {
                    profileEditPresentationID = nil
                }
        }
        .fullScreenCover(isPresented: $isWebsiteFullScreenPresented) {
            WebViewFullScreenModal(url: viewModel.profile.websiteURL)
        }
        .safeAreaInset(edge: .top) {
            HStack {
                Spacer()
                Button {
                    profileEditPresentationID = UUID()
                } label: {
                    Image(.edit)
                        .renderingMode(.template)
                        .foregroundStyle(.dayNightBlack)
                }
                .buttonStyle(.plain)
                .padding(.trailing, ProfileLoadedContentViewTheme.editButtonTrailingPadding)
            }
            .padding(.top, ProfileLoadedContentViewTheme.editButtonTopPadding)
        }
    }
}

private enum ProfileStackDestination: Hashable {
    case myNFT
    case favorites
}

#Preview {
    NavigationStack {
        ProfileLoadedContentView(
            viewModel: ProfileLoadedContentViewModel(
                profile: .profileScreenMock,
                profileService: ProfileServiceStub()
            )
        )
    }
}
