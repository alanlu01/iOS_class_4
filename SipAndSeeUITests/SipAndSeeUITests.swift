import XCTest

final class SipAndSeeUITests: XCTestCase {
    func testFullJourneyAndCaptureScreenshots() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-resetState"]
        app.launch()
        XCTAssertTrue(app.staticTexts["currentDrinkName"].waitForExistence(timeout: 10))
        capture(app, "01-home-latte")
        app.buttons["favorite_latte"].tap()
        let original = app.staticTexts["currentDrinkName"].label
        app.buttons["drawButton"].tap()
        XCTAssertNotEqual(app.staticTexts["currentDrinkName"].label, original)

        app.buttons["filter_清爽果香"].tap()
        XCTAssertEqual(app.staticTexts["currentDrinkName"].label, "橙光紅茶")
        XCTAssertFalse(app.buttons["drawButton"].isEnabled)
        capture(app, "02-citrus-filter")
        app.buttons["filter_濃郁奶香"].tap()
        if app.staticTexts["currentDrinkName"].label != "森系抹茶" { app.buttons["drawButton"].tap() }
        XCTAssertEqual(app.staticTexts["currentDrinkName"].label, "森系抹茶")
        capture(app, "03-matcha")
        app.buttons["favorite_matcha"].tap()
        app.buttons["detailButton"].tap()
        XCTAssertTrue(app.staticTexts["杯裡的配方"].waitForExistence(timeout: 5))
        capture(app, "04-recipe")
        app.buttons["完成"].tap()

        app.tabBars.buttons["飲品圖鑑"].tap()
        XCTAssertTrue(app.buttons["card_latte"].waitForExistence(timeout: 5))
        capture(app, "05-library")
        app.tabBars.buttons["我的收藏"].tap()
        XCTAssertTrue(app.buttons["card_latte"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["card_matcha"].exists)
        capture(app, "06-favorites")

        // 啟動參數只用於第一次清空資料；重啟後驗證真正的 UserDefaults 保存。
        app.terminate()
        app.launchArguments = []
        app.launch()
        app.tabBars.buttons["我的收藏"].tap()
        XCTAssertTrue(app.buttons["card_latte"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["card_matcha"].exists)
        app.buttons["favorite_latte"].tap()
        app.buttons["favorite_matcha"].tap()
        XCTAssertTrue(app.staticTexts["還在等一杯心動"].waitForExistence(timeout: 5))
        capture(app, "07-empty-favorites")
    }

    private func capture(_ app: XCUIApplication, _ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
