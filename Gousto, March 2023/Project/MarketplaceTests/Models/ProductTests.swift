import XCTest
@testable import Marketplace

// MARK: - Product Tests

class ProductTests: XCTestCase {

    func testSuccessfulDecode() throws {

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let product = try decoder.decode(Product.self, from: XCTUnwrap(mockData))

        XCTAssertEqual(product.id, "0009468c-33e9-11e7-b485-02859a19531d")
        XCTAssertEqual(product.sku, "AP-ACH-WIN-WHI-23-P")
        XCTAssertEqual(product.title, "Title")
        XCTAssertEqual(product.productDescription, "Description")
        XCTAssertEqual(product.listPrice, "6.88")
        XCTAssertEqual(product.isForSale, true)
        XCTAssertEqual(product.isAgeRestricted, true)
    }
}

// MARK: - Test Helpers

extension ProductTests {

    var mockData: Data? {
        """
        {
            "id": "0009468c-33e9-11e7-b485-02859a19531d",
            "sku": "AP-ACH-WIN-WHI-23-P",
            "title": "Title",
            "description": "Description",
            "list_price": "6.88",
            "is_vatable": true,
            "is_for_sale": true,
            "age_restricted": true,
            "box_limit": 2,
            "always_on_menu": false,
            "volume": 1000,
            "zone": "Ambient",
            "created_at": "2017-05-08T13:22:27+01:00",
            "attributes": [
                {
                  "id": "66f87c3e-c417-11e5-b4eb-02fada0dd3b9",
                  "title": "Allergen",
                  "unit": null,
                  "value": "sulphites"
                },
                {
                  "id": "92b6203a-f5a2-11e5-8fd2-02216daf9ab9",
                  "title": "Volume",
                  "unit": "ml",
                  "value": "750"
                }
            ],
            "tags": [],
            "images": {
                "750": {
                  "src": "https://production-media.gousto.co.uk/cms/product-image-landscape/YAddOns-WhiteWines-Borsao_013244-x750.jpg",
                  "url": "https://production-media.gousto.co.uk/cms/product-image-landscape/YAddOns-WhiteWines-Borsao_013244-x750.jpg",
                  "width": 750
                }
            }
        }
        """.data(using: .utf8)
    }
}
