//
//  CollectionByIdRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 28.04.2026.
//

import Foundation

struct CollectionByIdRequest: NetworkRequest {

    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections/\(id)")
    }
}
