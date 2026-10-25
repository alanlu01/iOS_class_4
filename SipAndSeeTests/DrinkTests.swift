import XCTest
@testable import SipAndSee

final class DrinkTests: XCTestCase {
    func testDrawsStayWithinFilterAndNeverRepeatWhenAlternativesExist() {
        for flavor in Flavor.allCases {
            var previous = Drink.menu[0]
            for _ in 0..<100 {
                let next = DrinkPicker.next(for: flavor, excluding: previous.id)
                XCTAssertTrue(DrinkPicker.candidates(for: flavor).contains(next))
                if DrinkPicker.candidates(for: flavor).count > 1 { XCTAssertNotEqual(next.id, previous.id) }
                previous = next
            }
        }
    }

    func testSingleChoiceAndUnknownPreviousDrink() {
        XCTAssertEqual(DrinkPicker.next(for: .fresh, excluding: "citrus").id, "citrus")
        XCTAssertTrue(Drink.menu.contains(DrinkPicker.next(for: .all, excluding: "unknown")))
    }

    func testFavoritesRoundTripAndStaleIDs() {
        let first = Favorites.toggled("latte", in: "")
        XCTAssertEqual(Favorites.decode(first), ["latte"])
        let second = Favorites.toggled("matcha", in: first)
        XCTAssertEqual(Favorites.decode(second), ["latte", "matcha"])
        XCTAssertEqual(Favorites.decode(Favorites.toggled("latte", in: second)), ["matcha"])
        XCTAssertEqual(Favorites.decode("deleted,latte,latte"), ["latte"])
    }
}
