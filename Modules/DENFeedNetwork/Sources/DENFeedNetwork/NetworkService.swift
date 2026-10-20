import Foundation

public protocol NetworkServiceProtocol {
    func requestAsync<T: Decodable, E: ResponseRequestable>(
        with endpoint: E
    ) async throws -> T where E.Response == T
}

public final class NetworkService {
    
    private let config: NetworkConfigurable
    private let session: URLSession
    
    public init(
        config: NetworkConfigurable,
        session: URLSession = .shared
    ) {
        self.config = config
        self.session = session
    }
    
    private func executeRequest(_ urlRequest: URLRequest) async throws -> (Data, HTTPURLResponse) {
        do {
            let (data, response) = try await session.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            return (data, httpResponse)
        } catch {
            throw resolve(error: error)
        }
    }
    
    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
    
    private func decode<T: Decodable>(
        data: Data,
        decoder: ResponseDecoder
    ) throws -> T {
        do {
            return try decoder.decode(data)
        } catch let decodingError as DecodingError {
            printIfDebug("❌ DECODING ERROR: \(decodingError)")
            if let bodyString = String(data: data, encoding: .utf8) {
                printIfDebug("--- FAILED TO DECODE THIS ---")
                printIfDebug(bodyString)
                printIfDebug("-----------------------------")
            }
            throw NetworkError.decodingError(message: "Failed to parse server response.")
        }
    }
    
    private func buildURLRequest(from endpoint: Requestable) throws -> URLRequest {
        do {
            return try endpoint.urlRequest(with: config)
        } catch {
            throw NetworkError.urlGeneration
        }
    }
}

extension NetworkService: NetworkServiceProtocol {
    
    public func requestAsync<T: Decodable, E: ResponseRequestable>(
        with endpoint: E
    ) async throws -> T where E.Response == T {
        
        let urlRequest = try buildURLRequest(from: endpoint)
        NetworkLogger.log(request: urlRequest)
        
        let (data, response) = try await executeRequest(urlRequest)
        
        NetworkLogger.log(responseData: data, response: response)
        
        return try decode(data: data, decoder: endpoint.responseDecoder)
    }
}

func printIfDebug(_ string: String) {
    #if DEBUG
    print(string)
    #endif
}
