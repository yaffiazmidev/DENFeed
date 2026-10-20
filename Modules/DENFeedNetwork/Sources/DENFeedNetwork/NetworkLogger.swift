import Foundation

public final class NetworkLogger {
    public static func log(request: URLRequest) {
        print("---------------------------------------------------")
        print("REQUEST = \(request.url?.absoluteString ?? "nil")")
        print("HEADERS = \(request.allHTTPHeaderFields ?? [:])")
        print("METHOD  = \(request.httpMethod ?? "nil")")
        if let httpBody = request.httpBody, let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
            printIfDebug("BODY:\n \(String(describing: result))")
        } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            printIfDebug("BODY:\n \(String(describing: resultString))")
        }
    }

    public static func log(responseData data: Data, response: HTTPURLResponse) {
        let icon: String
        switch response.statusCode {
        case 200..<300: icon = "✅ SUCCESS"
        case 400..<500: icon = "⚠️ CLIENT ERROR"
        default: icon = "❌ SERVER ERROR"
        }
        
        print("\n------------------ \(icon) • \(response.statusCode) ------------------")
        defer { print("------------------------------------------------\n") }

        let urlString = response.url?.absoluteString ?? "N/A"

        var output = """
        URL: \(urlString)
        """
        
        if data.isEmpty {
            output += "\n📥 RESPONSE • [Empty]"
        } else if let prettyResponse = prettyPrint(data: data) {
            output += "\n📥 RESPONSE • \(formatBytes(data.count))\n"

            let lines = prettyResponse.split(separator: "\n", omittingEmptySubsequences: false)
            let maxLines = 50
            let truncated = lines.count > maxLines

            for (index, line) in lines.prefix(maxLines).enumerated() {
                if index < maxLines {
                    output += "     \(line)\n"
                }
            }

            if truncated {
                output += "     ... (\(lines.count - maxLines) more lines truncated)\n"
            }
        } else {
            output += "\n📥 RESPONSE • (RAW):\n\(String(data: data, encoding: .utf8) ?? "Non-UTF8 data")"
        }
        
        print(output)
    }

    public static func log(error: Error) {
        printIfDebug("\(error)")
    }
}

extension NetworkLogger {
    // MARK: - Private Helpers
    
    private static func prettyPrint(data: Data) -> String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            return nil
        }
        return prettyString
    }
    
    private static func prettyPrint(dictionary: [String: Any]) -> String {
        return dictionary.map { key, value in "  \(key): \(value)" }.joined(separator: "\n")
    }
    
    private static func formatBytes(_ bytes: Int) -> String {
        if bytes < 1024 {
            return "\(bytes) B"
        } else if bytes < 1024 * 1024 {
            return String(format: "%.2f KB", Double(bytes) / 1024.0)
        } else {
            return String(format: "%.2f MB", Double(bytes) / (1024.0 * 1024.0))
        }
    }
}
