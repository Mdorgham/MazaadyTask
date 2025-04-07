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
        
        // طباعة تفاصيل الطلب
        printRequestDetails(urlRequest)
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            // طباعة تفاصيل الاستجابة
            printResponseDetails(data: data, response: response)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(NSError(domain: "", code: httpResponse.statusCode))
            }
            
            let decoder = JSONDecoder()
            let value = try decoder.decode(T.self, from: data)
            
            return Response(value: value, response: response)
        } catch let error as DecodingError {
            throw NetworkError.decodingError(error)
        } catch {
            throw NetworkError.serverError(error)
        }
    }
    
    // دالة لطباعة تفاصيل الطلب
    private func printRequestDetails(_ request: URLRequest) {
        print("\n�� REQUEST:")
        print("URL: \(request.url?.absoluteString ?? "")")
        print("Method: \(request.httpMethod ?? "")")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(bodyString)")
        }
    }
    
    // دالة لطباعة تفاصيل الاستجابة
    private func printResponseDetails(data: Data, response: URLResponse) {
        print("\n📡 RESPONSE:")
        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
            print("Headers: \(httpResponse.allHeaderFields)")
        }
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Body: \(jsonString)")
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
}
