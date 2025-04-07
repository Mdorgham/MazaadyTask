import Foundation

protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}

extension Request {
    var headers: [String: String]? {
        return NetworkConstants.Headers.headers
    }
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: NetworkConstants.baseURL + path) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        if let parameters = parameters {
            if method == .get {
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                request.url = components?.url
            } else {
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            }
        }
        
        return request
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkConstants {
    static let baseURL = "https://stagingapi.mazaady.com/api/v1"
    
    enum Headers {
        static let privateKey = "private-key"
        static let contentLanguage = "content-language"
        static let platform = "platform"
        
        static let headers: [String: String] = [
            privateKey: "Tg$LXgp7uK!D@aAj^aT3TmWY9a9u#qh5g&xgEETJ",
            contentLanguage: "en",
            platform: "ios"
        ]
    }
    
    enum Endpoints {
        static let categories = "/all-categories"
        static let properties = "/properties"
    }
}
