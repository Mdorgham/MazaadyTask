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
            let value = try decoder.decode(T.self, from: data)
            
            return Response(value: value, response: response)
        } catch let error as DecodingError {
            Logger.logError(error)
            throw NetworkError.decodingError(error)
        } catch {
            Logger.logError(error)
            throw NetworkError.serverError(error)
        }
    }
} 