import SwiftUI

struct DynamicFormView: View {
    @StateObject private var viewModel = CategoriesViewModel()
    @State private var selectedProperties: [Int: PropertiesResponse.Option] = [:]
    @State private var searchText = ""
    @State private var selectedCategory: Category?
    @State private var selectedProperty: PropertiesResponse.Property?
    @State private var propertiesData: [PropertiesResponse] = []
    
    let categories: [Category]
    
    var filteredCategories: [Category] {
        if searchText.isEmpty {
            return categories
        }
        return categories.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Categories Dropdown
            SearchableDropdown(
                title: "Main Category",
                items: filteredCategories,
                selectedItem: $selectedCategory,
                onItemSelected: { category in
                    Task {
                        if let id = category.id {
                            await viewModel.loadProperties(for: id)
                        }
                    }
                },
                displayName: { $0.name ?? "" }
            )
            
            // Properties Dropdown
            SearchableDropdown(
                title: "Sub Category",
                items: viewModel.properties,
                selectedItem: $selectedProperty,
                displayName: { $0.name ?? "" }
            )
            
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.error {
                Text(error.localizedDescription)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }

} 
