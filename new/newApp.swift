
import SwiftUI

@main
struct newApp: App {
    var body: some Scene {
        WindowGroup {
            ProductListView(
                viewModel: ProductViewModel()
            )
        }
    }
}
