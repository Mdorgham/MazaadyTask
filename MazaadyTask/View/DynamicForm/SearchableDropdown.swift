import SwiftUI

struct SearchableDropdown<T: Identifiable>: View {
    let title: String
    let items: [T]
    @Binding var selectedItem: T?
    @State private var isExpanded = false
    @State private var searchText = ""
    @State private var otherText = ""
    @State private var showOtherInput = false
    var onItemSelected: ((T) -> Void)?
    var onOtherSelected: ((String) -> Void)?
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
                        Text(selectedItem.map(displayName) ?? (showOtherInput ? otherText : "select"))
                            .foregroundColor(selectedItem != nil || showOtherInput ? .primary : .gray)
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
                            // Other Option
                            Button(action: {
                                showOtherInput = true
                            }) {
                                HStack {
                                    Text("Other")
                                        .foregroundColor(.red)
                                    Spacer()
                                    if showOtherInput {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Divider()
                            
                            // Other Input Field with OK Button
                            if showOtherInput {
                                HStack {
                                    TextField("Enter other value...", text: $otherText)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    
                                    Button(action: {
                                        if !otherText.isEmpty {
                                            onOtherSelected?(otherText)
                                        }
                                    }) {
                                        Text("OK")
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(otherText.isEmpty ? Color.gray : Color.blue)
                                            .cornerRadius(8)
                                    }
                                    .disabled(otherText.isEmpty)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                
                                Divider()
                            }
                            
                            // Regular Items
                            ForEach(filteredItems) { item in
                                Button(action: {
                                    selectedItem = item
                                    showOtherInput = false
                                    otherText = ""
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
