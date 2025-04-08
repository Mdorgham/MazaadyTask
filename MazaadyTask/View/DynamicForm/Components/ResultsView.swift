import SwiftUI

struct ResultsView: View {
    let category: String
    let subCategory: String
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Category")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Sub Category")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            
            // Content
            HStack {
                Text(category)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(subCategory)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(Color.white)
            
            Divider()
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
} 