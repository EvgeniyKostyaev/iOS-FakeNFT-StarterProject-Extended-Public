//
//  ProfileGetRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 14.04.2026.
//

import Foundation

struct ProfileGetRequest: NetworkRequest {

    let userId: String

    init(userId: String = ProfileAPIPath.gatewayProfilePathSegment) {
        self.userId = userId
    }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(userId)")
    }
}
