// MARK: - Product

/// ``Product`` represents the details of a product which can be sold on the Gousto marketplace.

import Foundation

struct ImageData: Codable {
    let src: String
    let url: URL
    let width: Int
}

struct Product: Identifiable {

    /// The type which represents the ID of a ``Product``.
    typealias ID = String

    /// The unique identifier of the product.
    let id: ID

    /// SKU which uniquely identifies the physical product.
    let sku: String

    /// The display title of the product.
    let title: String

    /// A brief description of the product.
    let productDescription: String

    /// The price of the product in GBP.
    let listPrice: String

    /// Whether the item is currently for sale or not.
    let isForSale: Bool

    /// Indicates whether the product can't be sold to anyone under the age of 18.
    let isAgeRestricted: Bool

    let images: [String: ImageData?]
}

// MARK: - Decodable conformance

extension Product: Decodable {

    /// The coding keys required to decode a ``Product`` from a JSON payload.
    private enum CodingKeys: String, CodingKey {
        case id
        case sku
        case title
        case productDescription = "description"
        case listPrice
        case isForSale
        case isAgeRestricted = "ageRestricted"
        case images
    }
}
