import Foundation

struct RemoteFeedItem: Decodable {
    let id: Int?
    let title: String?
    let body: String?
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case body
    }
}
