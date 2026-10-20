import Foundation
import DENFeedNetwork

struct FeedEndpoint {
    static func getPosts() -> Endpoint<[RemoteFeedItem]> {
        return Endpoint(path: "posts")
    }
}
