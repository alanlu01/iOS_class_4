# 驗證紀錄

日期：2026-10-25（台北時間）

## 已完成

- Xcode 27 Beta / iOS 27 Simulator 建置成功。
- 使用者實際操作後確認有畫面；提供的畫面顯示森系抹茶與第 2 次抽選，與狀態更新結果一致。
- `zsh scripts/test-model.sh` 通過：3,000 次依風味抽選、避免連續重複、單一選項、未知 ID、收藏新增與移除、UserDefaults 資料往返。
- 以 iPhone 17 Pro 模擬器擷取真正的 SwiftUI 畫面，檢查首頁、篩選、抹茶、配方、圖鑑、收藏與空收藏。

## 執行限制

`xcodebuild test` 在目前 Xcode 27 Beta 的模擬器服務連線階段停住，訊息為 `DTServiceHubClient failed to bless service hub`。已嘗試兩款模擬器與模擬器簽名建置，仍未能啟動 XCTest 執行。因此沒有宣稱 Xcode 單元測試套件或完整 UI 自動測試已通過；獨立模型檢查已通過，XCTest / UI 測試原始碼也保留在專案。

截圖使用 Debug 啟動參數指定起始飲品、篩選、頁籤與示範收藏。這些參數只改變初始資料；畫面由 App 在模擬器實際渲染，沒有以設計稿替代或修改畫面內容。這些截圖不作為完整操作流程通過的證據。

## 重現

```sh
zsh scripts/test-model.sh
export DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer
xcodebuild -project SipAndSee.xcodeproj -scheme SipAndSee \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=27.0' \
  -derivedDataPath build build
xcrun simctl install booted build/Build/Products/Debug-iphonesimulator/SipAndSee.app
python3 scripts/capture-screenshots.py <模擬器 UUID>
```

若同時有多個模擬器開機，將 `booted` 改成指定裝置的 UUID。
