import Foundation

struct NftDTO: Decodable, Sendable, Identifiable, Hashable {
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

extension NftDTO {
    func toDomain() -> Nft {
        Nft(
            id: id,
            name: name,
            images: images,
            rating: rating,
            description: description,
            price: price,
            author: author,
            websiteURL: website.flatMap(URL.init(string:)),
            createdAt: createdAt
        )
    }
}
