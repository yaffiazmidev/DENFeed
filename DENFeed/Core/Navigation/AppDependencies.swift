import Foundation

@Observable
class AppDependencies {

    func makeFeedViewModel() -> FeedViewModel {
        let networkService = DIContainer.shared.apiNetworkService
        let feedService = FeedService(networkService: networkService)
        return FeedViewModel(feedService: feedService)
    }
}
