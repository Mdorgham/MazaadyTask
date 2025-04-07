import SwiftUI

struct PropertySection: View {
    let property: PropertiesData
    let selectedOption: Option?
    let onOptionSelected: (Option) -> Void
    @State private var customValue: String = ""
    @State private var isExpanded = false
    
    var body: some View {
        Section(header: Text(property.name ?? "")) {
            DisclosureGroup(
                isExpanded: $isExpanded,
                content: {
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(property.options ?? [], id: \.id) { option in
                                Button(action: {
                                    onOptionSelected(option)
                                    isExpanded = false
                                }) {
                                    HStack {
                                        Text(option.name ?? "")
                                        Spacer()
                                        if selectedOption?.id == option.id {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                            
                            Button(action: {
                                let otherOption = Option(id: -1, name: "أخرى", hasChild: false)
                                onOptionSelected(otherOption)
                                isExpanded = false
                            }) {
                                Text("أخرى")
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .frame(maxHeight: 200)
                },
                label: {
                    Text(selectedOption?.name ?? "اختر قيمة")
                }
            )
            
            if selectedOption?.id == -1 {
                TextField("أدخل قيمة مخصصة", text: $customValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
    }
} 