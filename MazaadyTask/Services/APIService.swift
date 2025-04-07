import Foundation

class APIService {
    static let shared = APIService()
    private let networkManager = NetworkManager.shared
    
    func getCategories() async throws -> CategoriesResponse {
        let request = CategoriesRequest()
        let response: Response<CategoriesResponse> = try await networkManager.request(request)
        return response.value
    }
    
    func getProperties(for categoryId: Int) async throws -> PropertiesResponse {
        let request = PropertiesRequest(categoryId: categoryId)
        let response: Response<PropertiesResponse> = try await networkManager.request(request)
        return response.value
    }
}

// MARK: - Requests
struct CategoriesRequest: Request {
    var path: String { NetworkConstants.Endpoints.categories }
    var method: HTTPMethod { .get }
    var parameters: [String: Any]? { nil }
}

struct PropertiesRequest: Request {
    let categoryId: Int
    
    var path: String { NetworkConstants.Endpoints.properties }
    var method: HTTPMethod { .get }
    var parameters: [String: Any]? {
        ["cat": categoryId]
    }
}

enum APIError: Error {
    case invalidURL
    case noData
} 