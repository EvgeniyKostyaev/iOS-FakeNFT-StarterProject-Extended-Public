//
//  FavoriteNFTViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 06.04.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class FavoriteNFTViewModel {

    // MARK: - State

    enum State: Equatable {
        case idle
        case loading
        case ready([NftDTO])
        case failed(message: String)
    }

    private(set) var state: State = .idle
    private(set) var removeFavoriteErrorMessage: String?

    // MARK: - Computed Properties

    var cellModels: [FavoriteNFTCellModel] {
        guard case .ready(let nfts) = state else { return [] }
        return nfts.map(FavoriteNFTCellModel.init)
    }

    // MARK: - Public Methods

    func load(likedNFTIds: [String], nftService: NftService) async {
        guard !likedNFTIds.isEmpty else {
            state = .ready([])
            return
        }

        state = .loading

        var ordered: [NftDTO] = []
        ordered.reserveCapacity(likedNFTIds.count)

        for id in likedNFTIds {
            do {
                let nft = try await nftService.loadNft(id: id)
                ordered.append(nft)
            } catch {
                state = .failed(message: NSLocalizedString("FavoriteNFT.loadFailed", comment: ""))
                return
            }
        }

        state = .ready(ordered)
    }

    func clearRemoveFavoriteError() {
        removeFavoriteErrorMessage = nil
    }

    func removeFromFavorites(
        nftId: String,
        profile: ProfileScreen,
        profileService: ProfileServiceProtocol
    ) async {
        removeFavoriteErrorMessage = nil

        guard case .ready(let nfts) = state,
              profile.likes.contains(nftId) else { return }

        let newLikes = profile.likes.filter { $0 != nftId }
        let payload = ProfileUpdatePayload(
            name: profile.name,
            description: profile.description,
            website: profile.websiteURL.absoluteString,
            avatar: profile.avatarURL?.absoluteString ?? "",
            likes: newLikes,
            nfts: profile.nfts
        )

        do {
            try await profileService.updateProfile(payload)
            let filtered = nfts.filter { $0.id != nftId }
            state = .ready(filtered)
            NotificationCenter.default.post(name: .profileDidUpdate, object: nil)
        } catch {
            removeFavoriteErrorMessage = NSLocalizedString("FavoriteNFT.removeFailed", comment: "")
        }
    }
}
