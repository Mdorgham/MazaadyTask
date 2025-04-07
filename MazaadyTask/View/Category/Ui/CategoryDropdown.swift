import SwiftUI

struct CategoryDropdown: View {
    let categories: [Category]
    @Binding var selectedId: Int?
    @State private var isExpanded = false
    
    var body: some View {
        DisclosureGroup(
            isExpanded: $isExpanded,
            content: {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(categories, id: \.id) { category in
                            Button(action: {
                                selectedId = category.id
                                isExpanded = false
                            }) {
                                Text(category.name ?? "")
                                    .foregroundColor(.primary)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                .frame(maxHeight: 200)
            },
            label: {
                Text(selectedCategory?.name ?? "اختر الفئة")
            }
        )
    }
    
    private var selectedCategory: Category? {
        categories.first { $0.id == selectedId }
    }
} 