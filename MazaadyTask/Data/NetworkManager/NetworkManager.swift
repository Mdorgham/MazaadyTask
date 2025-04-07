import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 30
        session = URLSession(configuration: config)
    }
    
    func request<T: Codable>(_ request: Request) async throws -> Response<T> {
        guard let urlRequest = request.urlRequest else {
            throw NetworkError.invalidURL
        }
        
        Logger.logRequest(urlRequest)
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            Logger.logResponse(data: data, response: response)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "", code: httpResponse.statusCode)
                Logger.logError(error)
                throw NetworkError.serverError(error)
            }
            
            let decoder = JSONDecoder()
            do {
                let value = try decoder.decode(T.self, from: data)
                return Response(value: value, response: response)
            } catch let decodingError as DecodingError {
                Logger.logDecodingError(decodingError, data: data)
                throw NetworkError.decodingError(decodingError)
            }
        } catch let error as NetworkError {
            Logger.logError(error)
            throw error
        } catch {
            Logger.logError(error)
            throw NetworkError.serverError(error)
        }
    }
    
}
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
