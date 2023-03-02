
struct ProductResponseModel: Decodable {
    struct Price: Decodable {
        let currency: String
        let value: Double
    }
    
    struct Product: Decodable {
        let id: Int
        let image: String
        let brand: String
        let name: String
        let price: Price
        let discountPrice: Price?
    }
    
    let products: [Product]
    let nextPageUrl: String?
}
