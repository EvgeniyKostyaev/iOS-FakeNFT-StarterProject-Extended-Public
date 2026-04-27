import Foundation

protocol CollectionStorage: AnyObject {
    func saveCollection(_ collection: CollectionDTO) async
    func getCollection(with id: String) async -> CollectionDTO?
}

actor CollectionStorageImpl: CollectionStorage {
    private var storage: [String: CollectionDTO] = [:]

    func saveCollection(_ collection: CollectionDTO) async {
        storage[collection.id] = collection
    }

    func getCollection(with id: String) async -> CollectionDTO? {
        storage[id]
    }
}
