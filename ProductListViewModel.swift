//
//  ProductListViewModel.swift
//  new
//
//  Created by Yowaki on 26/2/2023.
//

import Foundation

import SwiftUI
import Combine

class ProductListViewModel: ObservableObject {
    @Published var products: [ProductModel] = []
    @Published var isPageLoading: Bool = false
    @Published var isRefreshing: Bool = false
    var nextPageUrl: String? = nil
    private let productService: ProductService
    private var cancellables = Set<AnyCancellable>()
    
    init(productService: ProductService) {
        self.productService = productService
        self.loadPage()
    }
    
    func shouldLoadNextPage(product: ProductModel) -> Bool {
        guard let lastProduct = products.last else {
            return false
        }
        return product.id == lastProduct.id
    }
    
    func loadPage() {
        guard !isPageLoading else { return }
        isPageLoading = true
        
        productService.fetchProducts(url: nextPageUrl)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure:
                    self?.nextPageUrl = nil
                case .finished:
                    break
                }
                self?.isPageLoading = false
            }, receiveValue: { [weak self] response in
                self?.nextPageUrl = response.nextPageUrl
                self?.products.append(contentsOf: response.products)
            })
            .store(in: &cancellables)
    }
    
    func loadNextPage() {
        guard !isPageLoading, let nextPageUrl = nextPageUrl else { return }
        self.nextPageUrl = nextPageUrl
        loadPage()
    }
    
    func refresh() {
        guard !isRefreshing else { return }
        isRefreshing = true
        
        productService.fetchProducts(url: nil)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure:
                    self?.products = []
                    self?.nextPageUrl = nil
                case .finished:
                    break
                }
                self?.isRefreshing = false
            }, receiveValue: { [weak self] response in
                self?.nextPageUrl = response.nextPageUrl
                self?.products = response.products
            })
            .store(in: &cancellables)
    }
}
