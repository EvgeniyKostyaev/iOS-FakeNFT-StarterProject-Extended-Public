import Foundation

@Observable
@MainActor
final class ServicesAssembly {
    
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let collectionsStorage: CollectionsStorage
    private let collectionStorage: CollectionStorage
    
    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage = NftStorageImpl(),
        collectionsStorage: CollectionsStorage = CollectionsStorageImpl(),
        collectionStorage: CollectionStorage = CollectionStorageImpl()
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.collectionsStorage = collectionsStorage
        self.collectionStorage = collectionStorage
    }
    
    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    
    var profileService: ProfileServiceProtocol {
        ProfileServiceImpl(networkClient: networkClient)
    }

    var orderService: OrderService {
        OrderServiceImpl(networkClient: networkClient)
    }

    var catalogService: CatalogService {
        CatalogServiceImpl(
            networkClient: networkClient,
            collectionsStorage: collectionsStorage,
            collectionStorage: collectionStorage
        )
    }
}
