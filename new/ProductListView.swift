//
//  ProductListView.swift
//  new
//
//  Created by Yowaki on 27/2/2023.
//

import Foundation
import SwiftUI

struct ProductListView: View {
    @ObservedObject var viewModel: ProductViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.products) { product in
                ProductRowView(product: product)
            }
            
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.errorMessage != "" {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
            } else if viewModel.nextPageUrl != nil {
                Button(action: {
                    viewModel.fetchNextPage()
                }) {
                    Text("Load More")
                }
            }
        }
        .onAppear {
            viewModel.fetchProducts()
        }
    }
}