//
//  ProfilePutRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 14.04.2026.
//

import Foundation

struct ProfilePutRequest: NetworkRequest {
    let payload: ProfileUpdatePayload

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(payload.userId)")
    }

    var httpMethod: HttpMethod { .put }

    var urlEncodedFormFields: [URLEncodedFormField] {
        [
            URLEncodedFormField(name: "name", value: payload.name),
            URLEncodedFormField(name: "description", value: payload.description),
            URLEncodedFormField(name: "website", value: payload.website),
            URLEncodedFormField(name: "avatar", value: payload.avatar),
            URLEncodedFormField(name: "likes", value: payload.likes.joined(separator: ",")),
            URLEncodedFormField(name: "nfts", value: payload.nfts.joined(separator: ","))
        ]
    }
}
