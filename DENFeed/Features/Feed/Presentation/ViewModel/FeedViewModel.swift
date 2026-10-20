//
//  FeedViewModel.swift
//  DENFeed
//
//  Created by DENAZMI on 10/12/25.
//


import Foundation
import DENFeedNetwork

@Observable
class FeedViewModel {
    
    private let feedService: FeedServiceProtocol
    var isLoading: Bool = false
    var feeds: [FeedItemViewModel] = []
    var errorMessage: String? = nil
    
    init(feedService: FeedServiceProtocol) {
        self.feedService = feedService
    }
    
    func loadData() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
                
        do {
            isLoading = false
            let response = try await feedService.getPosts()
            feeds = response.asViewModels
        } catch {
            isLoading = false
            let error = error as? NetworkError
            errorMessage = error?.errorDescription ?? "An unexpected error occurred."
        }
    }
}

extension Array where Element == RemoteFeedItem {
    var asViewModels: [FeedItemViewModel] {
        map({ .init(id: $0.id ?? 0, title: $0.title ?? "", body: $0.body ?? "") })
    }
}
