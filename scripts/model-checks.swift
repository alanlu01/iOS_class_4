import Foundation

@main
struct ModelChecks {
    static func main() {
        for flavor in Flavor.allCases {
            var previous = Drink.menu[0]
            for _ in 0..<1000 {
                let next = DrinkPicker.next(for: flavor, excluding: previous.id)
                precondition(DrinkPicker.candidates(for: flavor).contains(next), "抽選必須符合篩選")
                if DrinkPicker.candidates(for: flavor).count > 1 {
                    precondition(previous.id != next.id, "有其他選項時不可連續重複")
                }
                previous = next
            }
        }
        precondition(DrinkPicker.next(for: .fresh, excluding: "citrus").id == "citrus")
        precondition(Drink.menu.contains(DrinkPicker.next(for: .all, excluding: "deleted")))
        let saved = Favorites.toggled("matcha", in: Favorites.toggled("latte", in: ""))
        precondition(Favorites.decode(saved) == Set(["latte", "matcha"]))
        precondition(Favorites.decode(Favorites.toggled("latte", in: saved)) == Set(["matcha"]))
        precondition(Favorites.decode("deleted,latte,latte") == Set(["latte"]))
        let suite = "SipAndSee.ModelChecks.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defaults.set(saved, forKey: "savedDrinks")
        precondition(Favorites.decode(UserDefaults(suiteName: suite)!.string(forKey: "savedDrinks") ?? "") == Set(["latte", "matcha"]))
        defaults.removePersistentDomain(forName: suite)
        print("PASS: 3,000 filtered draws, no immediate repeats, single-option fallback, stale IDs, favorite add/remove, UserDefaults round trip.")
    }
}
