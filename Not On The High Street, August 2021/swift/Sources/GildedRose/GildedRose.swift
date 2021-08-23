/*
 Commentary
 ==========
 
 The plan of attack was roughly:
 
 * Look at the code.  Ew.  OK, that nested conditional is not maintainable.
 * Ah, there are no tests.
 * "GildedRose"?  That seems an unusual name.  I wonder if... Checked the repo history.  Ah, OK, I see.
 * Google for "GildedRose"
 * Knowing that it was a standard kata I looked at various discussions, read around the history.
 * Look at the rules again, try and get my head round them.
 * Rules?  OK, let's normalise them.  And if we can be declarative along the way...
 * But first, lets's put some tests in place.
 * Then I wrote a rule "engine". Tried a couple of rule configurations - include/exclude items,
   before settling on the approach herein.
 * Rewrote the tests, hand-walking various items through the rules.
 * Fleshed out the rules and the item-map
 * There's ambiguity in the brie/concert increases.  Separate brie-increase rule may be required.  Should
   be a live-coding opportunity.  Left in intentionally.
 * Test _coverage_ is good, but test _value_ is lower than it could be.  More edge cases required.
 * There's a discussion around the rules I'd have liked to have had prior to starting work but the situation
   didn't allow for it.
 * Looked at the spec, noted the requirement for configurable decrement.  OK, modified the rule init(),
   implemented a test.
 */

// MARK: - Convenience product name constants.  Would typically come from DB

public enum Constants {
    public static let SULFURAS = "Sulfuras, Hand of Ragnaros"
    public static let BACKSTAGEPASS = "Backstage passes to a TAFKAL80ETC concert"
    public static let BRIE = "Aged Brie"
    public static let DEXTERITYVEST = "+5 Dexterity Vest"
    public static let MONGOOSE = "Elixir of the Mongoose"
    public static let CAKE = "Conjured Mana Cake"
}

// MARK: - Business Rules.  Intentionally left in this file for convenience of viewing

public protocol Rule {
    func execute(item: Item)
}

/**
 * "At the end of each day our system lowers [the sellIn] value for every item"
 */
public class TimePasses: Rule {
    required public init() {}
    public func execute(item: Item) {
        item.sellIn -= 1
    }
}

/**
 * "At the end of each day our system lowers [the quality] value for every item"
 */
public class DecreaseQuality: Rule {
    
    /// The amount to take off the quality each day
    var decrement: Int = 1

    required public init(decrement: Int = 1) {
        self.decrement = decrement
    }
    
    public func execute(item: Item) {
        
        // "Once the sell by date has passed, Quality degrades twice as fast"
        item.quality -= item.sellIn >= 0 ? decrement : decrement * 2
        
        // "The Quality of an item is never negative"
        clampQuality(item)
    }
}
/**
 * "[item] actually increases in Quality the older it gets"
 */
public class IncreaseQuality: Rule {

    required public init() {}

    public func execute(item: Item) {
        
        // "Quality increases by 2 when there are 10 days or less and by 3 when there are 5 days or less"
        switch item.sellIn {
        case Int.min...5:
            item.quality += 3
        case 6...10:
            item.quality += 2
        default:
            item.quality += 1
        }
        
        // "The Quality of an item is never more than 50"
        clampQuality(item)
        
    }
}
/**
 * "The Quality of an item is never negative" / "The Quality of an item is never more than 50"
 */
func clampQuality(_ item: Item) {
    if item.quality < 0 {
        item.quality = 0
    }
    
    if item.quality > 50 {
        item.quality = 50
    }
}

/**
 * "Quality drops to 0 after the concert"
 */
public class AfterConcert: Rule {
    required public init() {}
    public func execute(item: Item) {
        // "Quality drops to 0 after the concert"
        if item.sellIn < 0 {
            item.quality = 0
        }
    }
}

// MARK: - Convenience Type aliases

public typealias ItemName = String

/// A Map of item identifiers (i.e. name) to business rules to be applied each day
public typealias RuleMap = [ItemName : [Rule]]

// MARK: - The main GildedRose class

public class GildedRose {
    var items: [Item]
    var rules: RuleMap
    
    public required init(items:[Item], rules: RuleMap) {
        self.items = items
        self.rules = rules
    }
    
    public func updateQuality() {
        
        // For each item apply all rules
        // There's an implicit temporal assumption in all this: updateQuality() is called once a day
        for item in items {
            if let itemRules = rules[item.name] {
                for rule in itemRules {
                    rule.execute(item: item)
                }
            }
        }
    }
}
