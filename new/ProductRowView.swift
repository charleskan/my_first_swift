//
//  ProductRowView.swift
//  new
//
//  Created by Yowaki on 26/2/2023.
//

import Foundation
import SwiftUI

struct ProductRowView: View {
    let product: ProductModel
    @State private var image: UIImage?
    
    var body: some View {
        VStack(alignment: .leading) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
            }
            
            Text("\(product.brand) \(product.name)")
                .font(.headline)
            
            HStack {
                Text(product.name)
                Text(String(format: "%.2f", product.price))
                    .font(.subheadline)
//                if let discountPrice = product.discountPrice {
//                    Text(product.price)
//                        .font(.subheadline)
//                        .strikethrough()
//                    Text(String(format: "%.2f", discountPrice.value))
//                        .font(.subheadline)
//                        .foregroundColor(.red)
//                }
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
            guard let url = URL(string: product.image) else {
                return
            }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    image = UIImage(data: data)
                }
            }.resume()
        }
}

