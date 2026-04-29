import Foundation

protocol CollectionsStorage: AnyObject {
    func saveCollections(_ collections: [CollectionDTO]) async
    func getCollections() async -> [CollectionDTO]?
}

actor CollectionsStorageImpl: CollectionsStorage {
    private var storage: [CollectionDTO] = []

    func saveCollections(_ collections: [CollectionDTO]) async {
        storage = collections
    }

    func getCollections() async -> [CollectionDTO]? {
        storage
    }
}
