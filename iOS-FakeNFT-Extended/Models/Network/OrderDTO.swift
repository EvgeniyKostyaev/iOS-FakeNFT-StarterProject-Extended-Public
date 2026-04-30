import Foundation

struct OrderDTO: Decodable, Sendable, Identifiable, Hashable {
    let id: String
    let nfts: [String]
}
