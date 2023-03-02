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
                Text(String(format: "%.2f", product.price))
                    .font(.subheadline)
                if product.discountPrice != nil {
                    Text("discountPrice")
                        .font(.subheadline)
                        .strikethrough()
                    Text(String(format: "%.2f", product.discountPrice!))
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            loadImage()
        }
        .onDisappear {
            image = nil
        }
    }
    
    private func loadImage() {
        guard image == nil else { return }
        DispatchQueue.global(qos: .background).async {
            guard let imageUrl = URL(string: product.image),
                  let data = try? Data(contentsOf: imageUrl),
                  let loadedImage = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.image = loadedImage
            }
        }
    }
}


