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
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(ProfileAPIPath.gatewayProfilePathSegment)")
    }

    var httpMethod: HttpMethod { .put }

    var urlEncodedFormFields: [URLEncodedFormField] {
        var fields: [URLEncodedFormField] = [
            URLEncodedFormField(name: "name", value: payload.name),
            URLEncodedFormField(name: "description", value: payload.description),
            URLEncodedFormField(name: "website", value: payload.website),
            URLEncodedFormField(name: "avatar", value: payload.avatar)
        ]
        if !payload.likes.isEmpty {
            fields.append(URLEncodedFormField(name: "likes", value: payload.likes.joined(separator: ",")))
        }
        if !payload.nfts.isEmpty {
            fields.append(URLEncodedFormField(name: "nfts", value: payload.nfts.joined(separator: ",")))
        }
        return fields
    }
}
