//
//  CatalogService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 28.04.2026.
//

import Foundation

protocol CatalogService {
    func loadCollections() async throws -> [CollectionDTO]
    func loadCollection(id: String) async throws -> CollectionDTO
}

@MainActor
final class CatalogServiceImpl: CatalogService {
    
    private let networkClient: NetworkClient
    private let collectionsStorage: CollectionsStorage
    private let collectionStorage: CollectionStorage

    init(networkClient: NetworkClient, collectionsStorage: CollectionsStorage, collectionStorage: CollectionStorage) {
        self.collectionsStorage = collectionsStorage
        self.collectionStorage = collectionStorage
        self.networkClient = networkClient
    }
    
    func loadCollections() async throws -> [CollectionDTO] {
        if let collections = await collectionsStorage.getCollections(),
            !collections.isEmpty {
            return collections
        }

        let request = CollectionsRequest()
        let collections: [CollectionDTO] = try await networkClient.send(request: request)
        await collectionsStorage.saveCollections(collections)
        return collections
    }
    
    func loadCollection(id: String) async throws -> CollectionDTO {
        if let collection = await collectionStorage.getCollection(with: id) {
            return collection
        }

        let request = CollectionByIdRequest(id: id)
        let collection: CollectionDTO = try await networkClient.send(request: request)
        await collectionStorage.saveCollection(collection)
        return collection
    }
}
