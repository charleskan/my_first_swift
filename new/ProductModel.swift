//
//  ProductModel.swift
//  new
//
//  Created by Yowaki on 26/2/2023.
//

struct ProductModel: Identifiable {
    let id: Int
    let image: String
    let brand: String
    let name: String
    let price: Double
    let discountPrice: Double?
    let nextPageUrl: String?
    

    init(from product: ProductResponseModel.Product, nextPageUrl: String?) {
        self.id = product.id
        self.image = product.image
        self.brand = product.brand
        self.name = product.name
        self.price = product.price.value
        self.discountPrice = product.discountPrice?.value
        self.nextPageUrl = nextPageUrl
    }
   
}
