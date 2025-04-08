import Foundation
import SwiftUI

// ViewModel to handle category and property data with loading states and error handling
class CategoriesViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var properties: [PropertiesResponse.Property] = []
    @Published var isLoading = false
    @Published var error: NetworkError?
    
    // Fetches all categories from the API and updates the UI state
    // Handles loading states and error cases
    func loadCategories() async {
        isLoading = true
        do {
            let response = try await APIService.shared.getCategories()
            await MainActor.run {
                categories = response.data?.categories ?? []
                isLoading = false
            }
        } catch let error as NetworkError {
            await MainActor.run {
                self.error = error
                isLoading = false
            }
        } catch {
            await MainActor.run {
                self.error = .unknown
                isLoading = false
            }
        }
    }
    
    // Fetches properties for a specific category ID
    // Updates the properties list and handles loading states and errors
    func loadProperties(for categoryId: Int) async {
        isLoading = true
        do {
            let response = try await APIService.shared.getProperties(for: categoryId)
            await MainActor.run {
                if let propertiesData = response.data {
                    properties = propertiesData
                }
                isLoading = false
            }
        } catch let error as NetworkError {
            await MainActor.run {
                self.error = error
                isLoading = false
            }
        } catch {
            await MainActor.run {
                self.error = .unknown
                isLoading = false
            }
        }
    }
}
