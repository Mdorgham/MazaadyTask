import SwiftUI

struct DynamicFormView: View {
    @StateObject private var viewModel = CategoriesViewModel()
    @State private var selectedCategory: Category?
    @State private var selectedProperty: PropertiesResponse.Property?
    @State private var showResults = false
    @State private var customCategory: String?
    @State private var customProperty: String?
    @State private var isLoading = false
    @State private var categoryDropdownKey = UUID()
    @State private var propertyDropdownKey = UUID()
    
    private func resetForm() {
        selectedCategory = nil
        selectedProperty = nil
        customCategory = nil
        customProperty = nil
        showResults = false
        viewModel.properties = []
        // Reset dropdowns by changing their keys
        categoryDropdownKey = UUID()
        propertyDropdownKey = UUID()
    }
    
    var body: some View {
        ZStack {
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
                                        isLoading = true
                                        await viewModel.loadProperties(for: id)
                                        isLoading = false
                                    }
                                }
                            }
                        ),
                        onOtherSelected: { text in
                            customCategory = text
                            selectedCategory = nil
                            showResults = true
                            // Reset property list, search field, and custom property
                            viewModel.properties = []
                            propertyDropdownKey = UUID()
                            customProperty = nil
                            selectedProperty = nil
                            // Reset category search text
                            categoryDropdownKey = UUID()
                        },
                        displayName: { $0.name ?? "" }
                    )
                    .id(categoryDropdownKey)
                    
                    // Property Dropdown
                    if !viewModel.properties.isEmpty || customCategory != nil {
                        SearchableDropdown(
                            title: "Property",
                            items: viewModel.properties,
                            selectedItem: Binding(
                                get: { selectedProperty },
                                set: { newValue in
                                    selectedProperty = newValue
                                    customProperty = nil
                                    showResults = true
                                }
                            ),
                            onOtherSelected: { text in
                                customProperty = text
                                selectedProperty = nil
                                showResults = true
                            },
                            displayName: { $0.name ?? ""}
                        )
                        .id(propertyDropdownKey)
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
            
            // Loading Overlay
            if isLoading {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        ProgressView()
                            .scaleEffect(1.5)
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    )
            }
        }
        .onAppear {
            Task {
                isLoading = true
                await viewModel.loadCategories()
                isLoading = false
            }
        }
    }
} 
