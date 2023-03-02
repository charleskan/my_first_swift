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
    private let font: String = "Rubik"
    
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 163, height: 163)
                        .cornerRadius(4)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 163, height: 163)
                        .cornerRadius(4)
                }
            }
            Spacer()
                .frame(height: 8)
            VStack(alignment: .leading) {
                Text(product.brand)
                    .font(.custom(font, size: 14))
                Text(product.name)
                    .font(.custom(font, size: 14))
                Spacer()
                    .frame(height: 52)
                HStack{
                    if product.discountPrice != nil {
                        Text("HKD \(String(format: "%.2f", product.discountPrice!))")
                            .font(.custom(font, size: 16))
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                        Text(String(format: "%.2f", product.price))
                            .font(.custom(font, size: 12))
                            .strikethrough()
                    }
                }
                    Spacer()
                        .frame(height: 15)
                    Button(action: {}) {
                        Text("即買")
                            .font(.custom(font, size: 14))
                            .foregroundColor(Color(red: 30/255, green: 27/255, blue: 22/255))
                    }
                    .frame(minWidth: 0, maxWidth: 163, minHeight: 0, maxHeight: .infinity)
                    .padding(8)
                    .padding(.horizontal, 10)
                    .background(Color(red: 255/255, green: 199/255, blue: 12/255))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            Spacer()
                .frame(height: 64)
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


