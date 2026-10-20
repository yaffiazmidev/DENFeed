import Foundation
import DENFeedNetwork

protocol FeedServiceProtocol {
    func getPosts() async throws -> [RemoteFeedItem]
}

final class FeedService: FeedServiceProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getPosts() async throws -> [RemoteFeedItem] {
        let endpoint = FeedEndpoint.getPosts()
        return try await networkService.requestAsync(with: endpoint)
    }
}
