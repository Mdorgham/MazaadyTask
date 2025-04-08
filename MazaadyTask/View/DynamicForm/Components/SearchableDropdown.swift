import SwiftUI

// Reusable dropdown component with search functionality
struct SearchableDropdown<T: Identifiable>: View {
    let title: String
    let items: [T]
    @Binding var selectedItem: T?
    let onOtherSelected: ((String) -> Void)?
    let displayName: (T) -> String
    
    @State private var isExpanded = false
    @State private var searchText = ""
    @State private var otherText = ""
    
    // Filter items based on search text
    private var filteredItems: [T] {
        if searchText.isEmpty {
            return items
        }
        return items.filter { displayName($0).lowercased().contains(searchText.lowercased()) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Dropdown title
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            
            VStack(spacing: 0) {
                // Search bar for filtering items
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search \(title)", text: $searchText)
                        .onChange(of: searchText) { _ in isExpanded = true }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                
                // Dropdown button showing selected item
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    HStack {
                        Text(selectedItem != nil ? displayName(selectedItem!) : "Select \(title)")
                            .foregroundColor(selectedItem != nil ? .black : .gray)
                        Spacer()
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                
                // Dropdown list with items
                if isExpanded {
                    ScrollView {
                        VStack(spacing: 0) {
                            // "Other" option with text input
                            if let onOtherSelected = onOtherSelected {
                                VStack(spacing: 8) {
                                    HStack {
                                        Text("Other")
                                            .foregroundColor(.red)
                                        Spacer()
                                        if selectedItem == nil {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .padding()
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        selectedItem = nil
                                    }
                                    
                                    HStack {
                                        TextField("Enter custom \(title)", text: $otherText)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                        Button("OK") {
                                            onOtherSelected(otherText)
                                            otherText = ""
                                        }
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(Color.blue)
                                        .cornerRadius(8)
                                    }
                                    .padding(.horizontal)
                                    .padding(.bottom, 8)
                                }
                                .background(Color(.systemGray6))
                                
                                Divider()
                            }
                            
                            // List of filtered items
                            ForEach(filteredItems) { item in
                                HStack {
                                    Text(displayName(item))
                                    Spacer()
                                    if selectedItem?.id == item.id {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding()
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedItem = item
                                    withAnimation {
                                        isExpanded = false
                                    }
                                }
                                
                                if item.id != filteredItems.last?.id {
                                    Divider()
                                }
                            }
                        }
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    .frame(maxHeight: 200)
                    .padding(.top, 4)
                }
            }
        }
        .padding(.horizontal)
    }
} 