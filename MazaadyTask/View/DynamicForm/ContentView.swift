import SwiftUI

struct FormCV: View {
    @StateObject private var viewModel = CategoriesViewModel()
    
    var body: some View {
        DynamicFormView(categories: viewModel.categories)
            .onAppear {
                Task {
                    await viewModel.loadCategories()
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FormCV()
    }
}

