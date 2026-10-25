import Foundation

enum Flavor: String, CaseIterable, Identifiable {
    case all = "隨心選", creamy = "濃郁奶香", fresh = "清爽果香"
    var id: String { rawValue }
}

struct Drink: Identifiable, Equatable {
    let id: String
    let name: String
    let english: String
    let image: String
    let category: Flavor
    let temperature: String
    let note: String
    let description: String
    let ingredients: [String]
    let steps: [String]

    static let menu: [Drink] = [
        Drink(id: "latte", name: "雲朵拿鐵", english: "Cloud Latte", image: "Latte", category: .creamy,
              temperature: "熱飲", note: "柔滑奶香・烘焙堅果", description: "讓綿密奶泡接住今天的疲憊。\n慢慢喝，生活也可以輕一點。",
              ingredients: ["濃縮咖啡 30 ml", "熱牛奶 180 ml", "細緻奶泡 適量"],
              steps: ["將濃縮咖啡倒進喜歡的杯子。", "把熱牛奶打出細緻奶泡。", "緩緩注入牛奶，鋪上奶泡就完成。"]),
        Drink(id: "matcha", name: "森系抹茶", english: "Forest Matcha", image: "Matcha", category: .creamy,
              temperature: "冰飲", note: "清新茶韻・醇厚奶香", description: "把一小片森林裝進杯裡。\n在茶香與奶香之間，找回自己的節奏。",
              ingredients: ["抹茶粉 3 g", "溫水 30 ml", "牛奶 180 ml", "冰塊 適量"],
              steps: ["用溫水將抹茶粉攪拌至滑順。", "在玻璃杯加入冰塊與牛奶。", "沿著杯緣倒入抹茶，喝前攪拌。"]),
        Drink(id: "citrus", name: "橙光紅茶", english: "Citrus Daydream", image: "Citrus", category: .fresh,
              temperature: "冰飲", note: "明亮柑橘・淡雅紅茶", description: "一口橙香，是午後的小小出走。\n讓平凡的一天，多一點陽光。",
              ingredients: ["放涼紅茶 180 ml", "柳橙汁 60 ml", "柳橙切片 1 片", "冰塊 適量"],
              steps: ["先泡好紅茶，放涼備用。", "杯中加入冰塊、柳橙汁與紅茶。", "放入柳橙片，輕輕攪拌即可。"])
    ]
}

enum DrinkPicker {
    static func candidates(for flavor: Flavor) -> [Drink] {
        Drink.menu.filter { flavor == .all || $0.category == flavor }
    }

    /// 多於一杯時排除目前飲品；只有一杯時安全地回傳該杯。
    static func next(for flavor: Flavor, excluding currentID: String) -> Drink {
        let candidates = candidates(for: flavor)
        let alternatives = candidates.filter { $0.id != currentID }
        return (alternatives.isEmpty ? candidates : alternatives).randomElement() ?? Drink.menu[0]
    }
}

enum Favorites {
    static func decode(_ value: String) -> Set<String> {
        Set(value.split(separator: ",").map(String.init)).intersection(Drink.menu.map(\.id))
    }
    static func toggled(_ id: String, in value: String) -> String {
        var ids = decode(value)
        if ids.contains(id) { ids.remove(id) } else { ids.insert(id) }
        return ids.sorted().joined(separator: ",")
    }
}
