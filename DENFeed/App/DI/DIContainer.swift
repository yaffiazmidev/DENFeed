import Foundation
import DENFeedNetwork

class DIContainer {
    static let shared = DIContainer()

    lazy var appConfiguration = AppConfiguration()

    lazy var apiNetworkService: NetworkServiceProtocol = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!,
                                          headers: ["Content-Type": "application/json"])
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 30.0
        configuration.timeoutIntervalForResource = 60.0
        return NetworkService(config: config, session: .init(configuration: configuration))
    }()
}
