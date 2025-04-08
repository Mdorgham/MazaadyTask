import Foundation

// Network service to handle API requests
class NetworkService {
    static let shared = NetworkService()
    private let baseURL = "https://staging.mazaady.com/api/v1"
    private let privateKey = "3%o8i}_;3D4bF]G5@22r2)Et1&mLJ4?$@+16"
    
    private init() {}
    
    // Fetch all categories from API
    func fetchCategories() async throws -> CategoriesResponse {
        let url = URL(string: "\(baseURL)/get_all_cats")!
        var request = URLRequest(url: url)
        request.addValue(privateKey, forHTTPHeaderField: "private-key")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(CategoriesResponse.self, from: data)
    }
    
    // Fetch properties for a specific category
    func fetchProperties(for categoryId: Int) async throws -> PropertiesResponse {
        let url = URL(string: "\(baseURL)/properties?cat=\(categoryId)")!
        var request = URLRequest(url: url)
        request.addValue(privateKey, forHTTPHeaderField: "private-key")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(PropertiesResponse.self, from: data)
    }
} 