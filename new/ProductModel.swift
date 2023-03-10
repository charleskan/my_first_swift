
struct ProductModel: Identifiable {
    let id: Int
    let image: String
    let brand: String
    let name: String
    let price: Double
    let currency: String
    let discountPrice: Double?
    let nextPageUrl: String?
    

    init(from product: ProductResponseModel.Product, nextPageUrl: String?) {
        self.id = product.id
        self.image = product.image
        self.brand = product.brand
        self.name = product.name
        self.price = product.price.value
        self.currency = product.price.currency
        self.discountPrice = product.discountPrice?.value
        self.nextPageUrl = nextPageUrl
    }
   
}
