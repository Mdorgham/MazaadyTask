import SwiftUI

struct DynamicFormView: View {
    @StateObject private var viewModel = CategoriesViewModel()
    @State private var selectedCategory: Category?
    @State private var selectedProperty: PropertiesResponse.Property?
    @State private var showResults = false
    @State private var customCategory: String?
    @State private var customProperty: String?
    
    private func resetForm() {
        selectedCategory = nil
        selectedProperty = nil
        customCategory = nil
        customProperty = nil
        showResults = false
        viewModel.properties = []
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Reset Button
                HStack {
                    Spacer()
                    Button(action: resetForm) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Reset")
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.red)
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                
                // Category Dropdown
                SearchableDropdown(
                    title: "Category",
                    items: viewModel.categories,
                    selectedItem: Binding(
                        get: { selectedCategory },
                        set: { newValue in
                            selectedCategory = newValue
                            customCategory = nil
                            if let id = newValue?.id {
                                Task {
                                    await viewModel.loadProperties(for: id)
                                }
                            }
                        }
                    ),
                    onOtherSelected: { text in
                        customCategory = text
                        selectedCategory = nil
                        showResults = true
                    },
                    displayName: { $0.name ?? "" }
                )
                
                // Property Dropdown
                if !viewModel.properties.isEmpty {
                    SearchableDropdown(
                        title: "Property",
                        items: viewModel.properties,
                        selectedItem: $selectedProperty,
                        onOtherSelected: { text in
                            customProperty = text
                            selectedProperty = nil
                            showResults = true
                        },
                        displayName: { $0.name ?? ""}
                    )
                }
                
                // Submit Button
                Button(action: {
                    showResults = true
                }) {
                    Text("Submit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .disabled((selectedCategory == nil && customCategory == nil) || (selectedProperty == nil && customProperty == nil))
                .opacity((selectedCategory == nil && customCategory == nil) || (selectedProperty == nil && customProperty == nil) ? 0.5 : 1)
                
                // Results View
                if showResults {
                    ResultsView(
                        category: customCategory ?? selectedCategory?.name ?? "",
                        subCategory: customProperty ?? selectedProperty?.name ?? ""
                    )
                }
            }
            .padding(.vertical)
        }
        .onAppear {
            Task {
               await viewModel.loadCategories()
            }
        }
    }
} 
