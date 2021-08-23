import GildedRose

let items = [
    Item(name: Constants.DEXTERITYVEST, sellIn: 10, quality: 20),
    Item(name: Constants.BRIE,          sellIn: 2,  quality: 0),
    Item(name: Constants.MONGOOSE,      sellIn: 5,  quality: 7),
    Item(name: Constants.SULFURAS,      sellIn: 0,  quality: 80),
    Item(name: Constants.SULFURAS,      sellIn: -1, quality: 80),
    Item(name: Constants.BACKSTAGEPASS, sellIn: 15, quality: 20),
    Item(name: Constants.BACKSTAGEPASS, sellIn: 10, quality: 49),
    Item(name: Constants.BACKSTAGEPASS, sellIn: 5,  quality: 49),
    Item(name: Constants.CAKE,          sellIn: 3,  quality: 6)]

// Business rules to apply to each type of object
// Depending on the configurability required these could easily be static clases
let rules: RuleMap = [
    Constants.DEXTERITYVEST : [DecreaseQuality(), TimePasses()],
    Constants.BRIE          : [IncreaseQuality(), TimePasses()],
    Constants.MONGOOSE      : [DecreaseQuality(), TimePasses()],
    Constants.SULFURAS      : [],
    Constants.BACKSTAGEPASS : [IncreaseQuality(), AfterConcert(), TimePasses()],
    Constants.CAKE          : [DecreaseQuality(decrement: 2), TimePasses()],
]

let app = GildedRose(items: items, rules: rules);

var days = 15;
if (CommandLine.argc > 1) {
    days = Int(CommandLine.arguments[1])! + 1
}

for i in 0..<days {
    print("-------- day \(i) --------");
    print("name, sellIn, quality");
    for item in items {
        print(item);
    }
    print("");
    app.updateQuality();
}
