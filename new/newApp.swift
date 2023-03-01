//
//  newApp.swift
//  new
//
//  Created by Yowaki on 26/2/2023.
//

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
