import Foundation

// ViewModel to handle category and property data
class CategoriesViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var properties: [PropertiesResponse.Property] = []
    
    // Load all categories from API
    func loadCategories() async {
        do {
            let response = try await NetworkService.shared.fetchCategories()
            DispatchQueue.main.async {
                self.categories = response.data.categories
            }
        } catch {
            print("Error loading categories: \(error)")
        }
    }
    
    // Load properties for a specific category
    func loadProperties(for categoryId: Int) async {
        do {
            let response = try await NetworkService.shared.fetchProperties(for: categoryId)
            DispatchQueue.main.async {
                self.properties = response.data
            }
        } catch {
            print("Error loading properties: \(error)")
        }
    }
} 