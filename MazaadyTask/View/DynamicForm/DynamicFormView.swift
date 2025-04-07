import SwiftUI

struct DynamicFormView: View {
    @State private var selectedCategoryId: Int?
    @State private var selectedSubcategoryId: Int?
    @State private var selectedProperties: [Int: Option] = [:]
    @State private var customValues: [Int: String] = [:]
    @State private var searchText = ""
    
    // State for properties data
    @State private var propertiesData: [PropertiesData] = []
    
    let categories: [Category]
    
    var filteredCategories: [Category] {
        if searchText.isEmpty {
            return categories
        }
        return categories.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
    }
    
    var body: some View {
        Form {
            Section(header: Text("الفئة الرئيسية")) {
                CategoryDropdown(
                    categories: filteredCategories,
                    selectedId: $selectedCategoryId
                )
            }
            
            if !propertiesData.isEmpty {
                ForEach(propertiesData, id: \.id) { property in
                    PropertySection(
                        property: property,
                        selectedOption: selectedProperties[property.id ?? 0],
                        onOptionSelected: { option in
                            handleOptionSelection(for: property, option: option)
                        }
                    )
                }
            }
            
            if !selectedProperties.isEmpty {
                Section(header: Text("القيم المحددة")) {
                    ForEach(Array(selectedProperties), id: \.key) { propertyId, option in
                        if let property = propertiesData.first(where: { $0.id == propertyId }) {
                            HStack {
                                Text(property.name ?? "")
                                Spacer()
                                Text(option.name ?? "")
                            }
                        }
                    }
                }
            }
            
            Section {
                Button("إرسال") {
                    submitForm()
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
            }
        }
        .onChange(of: selectedCategoryId) { newValue in
            if let id = newValue {
                loadProperties(for: id)
            }
        }
    }
    
    private func loadProperties(for categoryId: Int) {
        // API call implementation
    }
    
    private func handleOptionSelection(for property: PropertiesData, option: Option) {
        selectedProperties[property.id ?? 0] = option
        
        if option.hasChild ?? false {
            loadProperties(for: option.id ?? 0)
        }
    }
    
    private func submitForm() {
        // Form submission logic
    }
} 