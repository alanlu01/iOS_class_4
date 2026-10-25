# 一杯提案 Sip & See

SwiftUI 飲品靈感 App。按下「幫我選一杯」，同步切換飲品照片、名稱與介紹。作業主題對應 [彼得潘 #225：結合圖片、文字與 Button 的 State 練習](https://medium.com/彼得潘的試煉-勇者的-100-道-swift-ios-app-謎題/225-結合圖片-文字-button-的-swiftui-state-練習題-3cd0ca2b194d) 中的隨機 App。

<p align="center">
  <img src="Deliverables/screenshots/01-home-latte.png" width="240" alt="今日提案">
  <img src="Deliverables/screenshots/03-matcha.png" width="240" alt="森系抹茶">
  <img src="Deliverables/screenshots/06-favorites.png" width="240" alt="我的收藏">
</p>

## 交付內容

- [完整文章](Deliverables/ARTICLE.md)：已寫好，可複製使用。
- [文章網頁版](Deliverables/ARTICLE.html)：用瀏覽器開啟後可選取文章，複製到 Medium 編輯器；圖片也另附於截圖資料夾，便於上傳。
- [純文字文章](Deliverables/ARTICLE.txt)。
- [原始截圖](Deliverables/screenshots)：實際模擬器畫面。
- [文章封面](Deliverables/cover.png)。
- [已編譯的模擬器 App](Deliverables/SipAndSee-Simulator.zip)：適用 Apple Silicon Mac 與 iOS 27 模擬器；解壓縮後可使用 `xcrun simctl install booted SipAndSee.app` 安裝。
- [素材與生成提示詞](Deliverables/ASSETS.md)。

## 功能

- 今日提案：三款飲品，圖片與文字隨狀態更新。
- 風味篩選：隨心選、濃郁奶香、清爽果香；多個選項時不連續抽到同一杯。
- 單一選項提示：停用抽選並提示改選風味。
- 飲品圖鑑與杯中筆記：查看材料、份量和製作步驟。
- 我的收藏：使用 `@AppStorage` 保存，重新啟動後保留。
- 本機飲品圖片、原創程式繪製 App Icon，離線可用。

## 執行

1. 使用 Xcode 開啟 `SipAndSee.xcodeproj`。
2. 選擇 `SipAndSee` scheme 和 iPhone 模擬器，按 ⌘R。
3. 若要安裝到實體 iPhone，在 Signing & Capabilities 選擇自己的 Team。

部署目標為 iOS 17；本次使用 Xcode 27 Beta。已附上 `.xcodeproj`，不需要額外安裝依賴。`project.yml` 可用 XcodeGen 重新產生專案。

```sh
export DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer
xcodebuild -project SipAndSee.xcodeproj -scheme SipAndSee \
  -destination 'platform=iOS Simulator,name=iPhone 17,OS=27.0' \
  -parallel-testing-enabled NO test
```

## 專案結構

| 檔案 | 內容 |
| --- | --- |
| `SipAndSee/Drink.swift` | 飲品模型、篩選、抽選及收藏編碼 |
| `SipAndSee/ContentView.swift` | 首頁、圖鑑與收藏 |
| `SipAndSee/DrinkDetail.swift` | 材料與製作步驟 |
| `SipAndSee/Style.swift` | 共用色彩與標題元件 |
| `SipAndSeeTests` | 抽選邊界與收藏資料單元測試 |
| `SipAndSeeUITests` | 操作流程、保存驗證及截圖 |

## 驗證狀態

模擬器建置成功；獨立 Swift 模型檢查通過，涵蓋 3,000 次篩選抽選及收藏資料往返。使用者已實際操作首頁並確認切換飲品。Xcode 27 Beta 的模擬器服務連線問題阻止了 XCTest / UI 自動測試啟動，詳見[驗證紀錄](Deliverables/VERIFICATION.md)。
