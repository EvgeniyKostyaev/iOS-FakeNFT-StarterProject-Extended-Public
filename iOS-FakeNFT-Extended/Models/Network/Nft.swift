import Foundation

struct Nft: Decodable, Sendable, Identifiable, Hashable {
    let id: String
    let name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let website: String?
    let createdAt: String?

    var previewImageURL: URL? {
        images.first
    }
}
