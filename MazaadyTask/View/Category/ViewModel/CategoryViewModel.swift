import Foundation
import SwiftUI

class CategoriesViewModel: ObservableObject {
    @Published var categories: [Category] = []
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
}
