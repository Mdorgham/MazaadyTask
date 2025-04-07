import SwiftUI

struct ContentView: View {
    @State private var categories: [Category] = []
    
    var body: some View {
        DynamicFormView(categories: categories)
            .onAppear {
                loadCategories()
            }
    }
    
    private func loadCategories() {
        // API call to load categories
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
} 