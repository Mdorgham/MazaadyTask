import SwiftUI

// View to display selected category and property
struct ResultsView: View {
    let category: String
    let subCategory: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Results title
            Text("Results")
                .font(.title)
                .fontWeight(.bold)
            
            // Category result section
            VStack(alignment: .leading, spacing: 8) {
                Text("Category")
                    .font(.headline)
                    .foregroundColor(.gray)
                Text(category)
                    .font(.body)
            }
            
            // Property result section
            VStack(alignment: .leading, spacing: 8) {
                Text("Property")
                    .font(.headline)
                    .foregroundColor(.gray)
                Text(subCategory)
                    .font(.body)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
} 