import Foundation

public enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
    case invalidResponse
    case decodingError(message: String)
    case unknown(message: String)
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .error(statusCode, _):
            return "Server error (\(statusCode))."
        case .notConnected:
            return "No internet connection."
        case .cancelled:
            return "Request was cancelled."
        case .generic:
            return "Something went wrong. Please try again."
        case .urlGeneration:
            return "Failed to build URL."
        case .invalidResponse:
            return "Invalid server response."
        case let .decodingError(message):
            return message
        case let .unknown(message):
            return "Unknown error: \(message)"
        }
    }
}

public extension NetworkError {
    var isNotFoundError: Bool { return hasStatusCode(404) }
    
    func hasStatusCode(_ codeError: Int) -> Bool {
        switch self {
        case let .error(code, _):
            return code == codeError
        default: return false
        }
    }
}
