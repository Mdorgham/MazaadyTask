import Foundation

enum Logger {
    static func logRequest(_ request: URLRequest) {
        print("\n🌐 REQUEST:")
        print("URL: \(request.url?.absoluteString ?? "")")
        print("Method: \(request.httpMethod ?? "")")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(bodyString)")
        }
    }
    
    static func logResponse(data: Data, response: URLResponse) {
        print("\n📡 RESPONSE:")
        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
            print("Headers: \(httpResponse.allHeaderFields)")
        }
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Body: \(jsonString)")
        }
    }
    
    static func logError(_ error: Error) {
        print("\n❌ ERROR:")
        print("Description: \(error.localizedDescription)")
        if let networkError = error as? NetworkError {
            print("Network Error: \(networkError.localizedDescription)")
        }
    }
    
    static func logDecodingError(_ error: DecodingError, data: Data) {
        print("\n🔍 DECODING ERROR:")
        switch error {
        case .typeMismatch(let type, let context):
            print("Type Mismatch: Expected \(type)")
            print("Context: \(context.debugDescription)")
            print("Coding Path: \(context.codingPath.map { $0.stringValue })")
            
        case .valueNotFound(let type, let context):
            print("Value Not Found: Expected \(type)")
            print("Context: \(context.debugDescription)")
            print("Coding Path: \(context.codingPath.map { $0.stringValue })")
            
        case .keyNotFound(let key, let context):
            print("Key Not Found: \(key.stringValue)")
            print("Context: \(context.debugDescription)")
            print("Coding Path: \(context.codingPath.map { $0.stringValue })")
            
        case .dataCorrupted(let context):
            print("Data Corrupted")
            print("Context: \(context.debugDescription)")
            print("Coding Path: \(context.codingPath.map { $0.stringValue })")
            
        @unknown default:
            print("Unknown Decoding Error: \(error)")
        }
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("\nRaw JSON Data:")
            print(jsonString)
        }
    }
} 