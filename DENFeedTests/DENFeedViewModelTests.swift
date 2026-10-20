//
//  DENFeedViewModelTests.swift
//  DENFeed
//
//  Created by DENAZMI on 11/12/25.
//


import XCTest
import DENFeedNetwork
@testable import DENFeed

@MainActor
final class DENFeedViewModelTests: XCTestCase {
    
    var service: FeedServiceProtocol!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        service = FeedService(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        service = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    func test_FeedViewModelLoadDataSuccess() async throws {
        // Given
        let mockService = MockFeedService()
        let viewModel = FeedViewModel(feedService: mockService)

        // When
        await viewModel.loadData()

        // Then
        XCTAssertEqual(viewModel.feeds.count, 2)
        XCTAssertEqual(viewModel.feeds.first?.title, "Test Post 1")
        XCTAssertEqual(viewModel.feeds.first?.body, "Test Body 1")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    func test_FeedViewModelLoadDataFailure() async throws {
        // Given
        let mockService = MockFailingFeedService()
        let viewModel = FeedViewModel(feedService: mockService)

        // When
        await viewModel.loadData()

        // Then
        XCTAssertTrue(viewModel.feeds.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
}
// MARK: - Mock Services

class MockFeedService: FeedServiceProtocol {
    func getPosts() async throws -> [RemoteFeedItem] {
        // Create mock data from JSON to work with the Decodable struct
        let jsonData = """
        [
            {"id": 1, "title": "Test Post 1", "body": "Test Body 1"},
            {"id": 2, "title": "Test Post 2", "body": "Test Body 2"}
        ]
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let mockPosts = try decoder.decode([RemoteFeedItem].self, from: jsonData)
        return mockPosts
    }
}

class MockFailingFeedService: FeedServiceProtocol {
    func getPosts() async throws -> [RemoteFeedItem] {
        throw NetworkError.notConnected
    }
}

class MockNetworkService: NetworkServiceProtocol {
    var result: Any?
    var error: Error?
    var lastEndpointCalled: URLRequest?
    
    func requestAsync<T, E>(with endpoint: E) async throws -> T where T : Decodable, T == E.Response, E : DENFeedNetwork.ResponseRequestable {
        let config: ApiDataNetworkConfig = .init(baseURL: URL(string: "https://api.example.com")!)
        lastEndpointCalled = try endpoint.urlRequest(with: config)
        
        if let error = error {
            throw error
        }
        
        if let result = result as? T {
            return result
        }
        
        throw NetworkError.unknown(message: "Mock result not set")
    }
}
