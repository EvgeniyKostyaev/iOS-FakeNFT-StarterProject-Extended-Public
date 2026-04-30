//
//  CatalogCollectionsSorter.swift
//  iOS-FakeNFT-Extended
//
//  Created by Evgeniy Kostyaev on 30.04.2026.
//

import Foundation

struct CatalogCollectionsSorter {
    func sort(
        _ collections: [Collection],
        by sorting: CatalogSorting
    ) -> [Collection] {
        switch sorting {
        case .byName:
            collections.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        case .byNftCount:
            collections.sorted {
                if $0.nfts.count == $1.nfts.count {
                    return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
                }

                return $0.nfts.count > $1.nfts.count
            }
        }
    }
}
