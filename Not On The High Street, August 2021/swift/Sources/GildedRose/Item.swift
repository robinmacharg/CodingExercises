
public class Item {
    var name: String
    var sellIn: Int
    var quality: Int

    public init(name: String, sellIn: Int, quality: Int) {
        self.name = name
        self.sellIn = sellIn
        self.quality = quality
    }
}

extension Item: CustomStringConvertible {
    public var description: String {
        return "\(name), \(sellIn), \(quality)"
    }
}
