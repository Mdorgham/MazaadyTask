import SwiftUI

struct CategoryDropdown: View {
    let categories: [Category]
       @Binding var selectedId: Int?
       @State private var isExpanded = false
       @State private var searchText = ""
       var onCategorySelected: ((Int) -> Void)?
    
    var filteredCategories: [Category] {
        if searchText.isEmpty {
            return categories
        }
        return categories.filter { category in
            category.name?.localizedCaseInsensitiveContains(searchText) ?? false
        }
    }
    
    var body: some View {
        DisclosureGroup(
            isExpanded: $isExpanded,
            content: {
                VStack(spacing: 0) {
                    // Search Bar
                    TextField("ابحث عن فئة...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    
                    // Categories List
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(filteredCategories, id: \.id) { category in
                                Button(action: {
                                    selectedId = category.id
                                    isExpanded = false
                                    if let id = category.id {
                                        onCategorySelected?(id)
                                    }
                                }) {
                                    HStack {
                                        Text(category.name ?? "")
                                            .foregroundColor(.primary)
                                        Spacer()
                                        if selectedId == category.id {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                if category.id != filteredCategories.last?.id {
                                    Divider()
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 300)
                }
            },
            label: {
                HStack {
                    Text(selectedCategory?.name ?? "اختر الفئة")
                    Spacer()
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
            }
        )
    }
    
    private var selectedCategory: Category? {
        categories.first { $0.id == selectedId }
    }
}
