//
//  ProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 13.04.2026.
//

import SwiftUI

struct ProfileView: View {
    @Environment(ServicesAssembly.self) private var services
    @State private var viewModel = ProfileViewModel()
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.whiteTheme).ignoresSafeArea())
            case .loaded(let profile):
                loadedContent(profile: profile)
            case .failed(let message):
                VStack(spacing: 16) {
                    Text(message)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color(.blackTheme))
                    Button(NSLocalizedString("Error.repeat", comment: "")) {
                        viewModel.retryLoading(profileService: services.profileService)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.whiteTheme).ignoresSafeArea())
            }
        }
        .onAppear {
            Task { 
                await viewModel.loadProfile(profileService: services.profileService) 
            }
        }
    }
    
    @ViewBuilder
    private func loadedContent(profile: ProfileScreen) -> some View {
        List {
            Section {
                headerSection(profile: profile)
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                
                websiteSection(profile: profile)
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
            
            Section {
                NavigationLink {
                    MyNFTView(profile: profile)
                } label: {
                    profileMenuTitle(
                        formatKey: "Profile.myNFTsFormat",
                        count: profile.ownedNFTCount
                    )
                }
                .navigationLinkIndicatorVisibility(.hidden)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                
                NavigationLink {
                    FavoriteNFTView(profile: profile)
                } label: {
                    profileMenuTitle(
                        formatKey: "Profile.favoritesFormat",
                        count: profile.favoriteNFTCount
                    )
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
        .background(Color(.whiteTheme).ignoresSafeArea())
        .safeAreaInset(edge: .top) {
            HStack {
                Spacer()
                NavigationLink {
                    ProfileEditView(profile: profile)
                } label: {
                    Image(.edit)
                        .renderingMode(.template)
                        .foregroundStyle(Color(.blackTheme))
                }
                .buttonStyle(.plain)
                .padding(.trailing, 8)
            }
            .padding(.top, 8)
        }
    }
    
    private func headerSection(profile: ProfileScreen) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack(alignment: .center, spacing: 16) {
                
                avatarView(profile: profile)
                
                Text(profile.name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(Color(.blackTheme))
            }
            
            Text(profile.description)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(Color(.blackTheme))
                .lineSpacing(4)
        }
    }

    private func avatarView(profile: ProfileScreen) -> some View {
        Group {
            if let url = profile.avatarURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 70, height: 70)
                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        avatarPlaceholder
                    @unknown default:
                        avatarPlaceholder
                    }
                }
            } else {
                avatarPlaceholder
            }
        }
        .frame(width: 70, height: 70)
        .clipShape(Circle())
    }

    private var avatarPlaceholder: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFit()
            .foregroundStyle(Color(.lightGreyTheme))
    }

    private func websiteSection(profile: ProfileScreen) -> some View {
        NavigationLink {
            WebViewRepresentable(url: profile.websiteURL)
        } label: {
            Text(profile.websiteTitle)
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(Color(.blueUniversal))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationLinkIndicatorVisibility(.hidden)
    }

    private func profileMenuTitle(formatKey: String, count: Int) -> some View {
        HStack {
            Text(String(format: NSLocalizedString(formatKey, comment: ""), count))
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color(.blackTheme))
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color(.blackTheme))
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
    .environment(ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl()))
}
