//
//  ProductViewModel.swift
//  new
//
//  Created by Yowaki on 26/2/2023.
//

import Foundation
import Combine

class ProductViewModel: ObservableObject {
    @Published var products = [ProductModel]()
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    var nextPageUrl: String?
    private static let baseUrl = "https://everuts-codetest.s3.ap-southeast-1.amazonaws.com"
    private static let productEndpoint = "/products_1.json"

    private var cancellables = Set<AnyCancellable>()
    
    func fetchProducts() {
        guard let url = URL(string: ProductViewModel.baseUrl + ProductViewModel.productEndpoint + (nextPageUrl ?? "")) else {
            errorMessage = "Invalid URL"
            return
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let task = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: ProductResponseModel.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { response in
                self.products = response.products.map { ProductModel(from: $0, nextPageUrl: response.nextPageUrl == nil ? nil : "/" + response.nextPageUrl!) }
                self.nextPageUrl = response.nextPageUrl
            })
        
        isLoading = true
        task.store(in: &cancellables)
    }

    
    func fetchNextPage() {
        guard let nextPageUrl = nextPageUrl, !isLoading else {
            return
        }
        
        guard let url = URL(string: ProductViewModel.baseUrl + "/" + (nextPageUrl ?? "")) else {
            errorMessage = "Invalid URL"
            return
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let task = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: ProductResponseModel.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { response in
                self.products.append(contentsOf: response.products.map { ProductModel(from: $0, nextPageUrl: response.nextPageUrl == nil ? nil : "/" + response.nextPageUrl!) })
                self.nextPageUrl = response.nextPageUrl
            })
        
        isLoading = true
        task.store(in: &cancellables)
    }
    
    private func handleProductResponse(_ products: [ProductResponseModel.Product]) {
        self.products = products.map { ProductModel(from: $0, nextPageUrl: "") }
        self.nextPageUrl = products.isEmpty ? nil : nextPageUrl
    }
}
