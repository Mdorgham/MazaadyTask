import Foundation
import SwiftUI

class CategoriesViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var properties: [PropertiesResponse.Property] = []
    @Published var isLoading = false
    @Published var error: NetworkError?
    
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
