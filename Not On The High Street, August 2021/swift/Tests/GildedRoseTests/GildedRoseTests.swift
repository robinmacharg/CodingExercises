import Foundation
import XCTest

@testable import GildedRose

/**
 * A reminder of the business logic:
 *
 *   - All items have a SellIn value which denotes the number of days we have to sell the item
 *   - All items have a Quality value which denotes how valuable the item is
 *   - At the end of each day our system lowers both values for every item ✅
 *
 *   - Once the sell by date has passed, Quality degrades twice as fast ✅
 *   - The Quality of an item is never negative ✅
 *   - "Aged Brie" actually increases in Quality the older it gets ✅
 *   - The Quality of an item is never more than 50 ✅
 *   - "Sulfuras", being a legendary item, never has to be sold or decreases in Quality ✅
 *   - "Backstage passes", like aged brie, increases in Quality as its SellIn value approaches; ✅
 *   - Quality increases by 2 when there are 10 days or less and by 3 when there are 5 days or less but ✅
 *   - Quality drops to 0 after the concert ✅
 */
class GildedRoseTests: XCTestCase {
    func testDecreasesQuality() {
        let items = [
            Item(name: Constants.DEXTERITYVEST, sellIn: 10, quality: 20),
        ]
        let rules: RuleMap = [
            Constants.DEXTERITYVEST : [DecreaseQuality(), TimePasses()]
        ]
        let app = GildedRose(items: items, rules: rules)
        
        let expectedQuality = [
            19, 18, 17, 16, 15, 14, 13, 12, 11, 10,
            9, 7, 5, 3, 1, // "Once the sell by date has passed, Quality degrades twice as fast"
            0, 0, 0, 0, 0] // "The Quality of an item is never negative"
        
        let days = 20
        for i in 0..<days {
            app.updateQuality()
            print(items[0])
            XCTAssertEqual(items[0].quality, expectedQuality[i])
        }
    }
    
    func testIncreasesQualityBrie() {
        let items = [
            Item(name: Constants.BRIE, sellIn: 13, quality: 0),
        ]
        let rules: RuleMap = [
            Constants.BRIE : [IncreaseQuality(), TimePasses()]
        ]
        let app = GildedRose(items: items, rules: rules)
        
        let expectedQuality = [
            1, 2, 3, // "Aged Brie" actually increases in Quality the older it gets"
            5, 7, 9, 11, 13, // "Quality increases by 2 when there are 10 days or less"
            16, 19, 22, 25, 28, 31, 34, 37, 40, 43, 46, 49, // "and by 3 when there are 5 days or less"
            50, 50, 50] // "The Quality of an item is never more than 50"
        
        let days = 23
        for i in 0..<days {
            app.updateQuality()
            XCTAssertEqual(items[0].quality, expectedQuality[i])
        }
    }
    
    func testIncreasesQualityTicket() {
        let items = [
            Item(name: Constants.BACKSTAGEPASS, sellIn: 13, quality: 0),
        ]
        let rules: RuleMap = [
            Constants.BACKSTAGEPASS : [IncreaseQuality(), AfterConcert(), TimePasses()]
        ]
        let app = GildedRose(items: items, rules: rules)
        
        let expectedQuality = [
            1, 2, 3, // "Aged Brie" actually increases in Quality the older it gets"
            5, 7, 9, 11, 13, // "Quality increases by 2 when there are 10 days or less"
            16, 19, 22, 25, 28, 31, // "and by 3 when there are 5 days or less"
            0, 0] // "Quality drops to 0 after the concert"
        
        let days = 16
        for i in 0..<days {
            app.updateQuality()
            XCTAssertEqual(items[0].quality, expectedQuality[i])
        }
    }
    
    func testSulfuras() {
        let items = [
            Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 5, quality: 80),
        ]
        let rules: RuleMap = [
            Constants.SULFURAS : []
        ]
        let app = GildedRose(items: items, rules: rules)
        
        let days = 16
        for _ in 0..<days {
            app.updateQuality()
            XCTAssertEqual(items[0].quality, 80)
        }
    }
    
    func testRandomObject() {
        let name = "Nathanial, a Shodow of his former self"
        let items = [
            Item(name: name, sellIn: 5, quality: 80),
        ]
        let rules: RuleMap = [
            name : [DecreaseQuality(), TimePasses()]
        ]
        let app = GildedRose(items: items, rules: rules)
        
        let expectedQuality = [50, 49, 48, 47, 46, 45, 43, 41, 39, 37, 35, 33, 31]
        
        let days = 13
        for i in 0..<days {
            app.updateQuality()
            XCTAssertEqual(items[0].quality, expectedQuality[i])
        }
    }
    
    func testCakeDecreases() {
        let items = [
            Item(name: Constants.CAKE, sellIn: 5, quality: 20),
        ]
        let rules: RuleMap = [
            Constants.CAKE : [DecreaseQuality(decrement: 2), TimePasses()]
        ]
        let app = GildedRose(items: items, rules: rules)
        
        let expectedQuality = [18, 16, 14, 12, 10, 8,
                               4, // "Once the sell by date has passed, Quality degrades twice as fast"
                               0, 0, 0]
        
        let days = 10
        for i in 0..<days {
            app.updateQuality()
            print(items[0])
            XCTAssertEqual(items[0].quality, expectedQuality[i])
        }
    }
}
