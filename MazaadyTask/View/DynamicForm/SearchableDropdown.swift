import SwiftUI

struct SearchableDropdown<T: Identifiable>: View {
    let title: String
    let items: [T]
    @Binding var selectedItem: T?
    @State private var isExpanded = false
    @State private var searchText = ""
    var onItemSelected: ((T) -> Void)?
    var displayName: (T) -> String
    
    var filteredItems: [T] {
        if searchText.isEmpty {
            return items
        }
        return items.filter { item in
            displayName(item).localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                // Search Bar
                TextField("Search...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Dropdown Button
                Button(action: {
                    isExpanded.toggle()
                }) {
                    HStack {
                        Text(selectedItem.map(displayName) ?? "select")
                            .foregroundColor(selectedItem != nil ? .primary : .gray)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                
                // Dropdown List
                if isExpanded {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(filteredItems) { item in
                                Button(action: {
                                    selectedItem = item
                                    isExpanded = false
                                    onItemSelected?(item)
                                }) {
                                    HStack {
                                        Text(displayName(item))
                                            .foregroundColor(.primary)
                                        Spacer()
                                        if selectedItem?.id == item.id {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                if item.id != filteredItems.last?.id {
                                    Divider()
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 300)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                }
            }
        }
        .padding(.horizontal)
    }
}
