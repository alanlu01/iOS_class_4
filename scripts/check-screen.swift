import AppKit

let data = try Data(contentsOf: URL(fileURLWithPath: CommandLine.arguments[1]))
let bitmap = NSBitmapImageRep(data: data)!
let color = bitmap.colorAt(x: 12, y: bitmap.pixelsHigh / 2)!.usingColorSpace(.deviceRGB)!
// 啟動畫面為白色；正式頁面邊緣為米白色。
exit(color.greenComponent < 0.985 && color.blueComponent < 0.96 ? 0 : 1)
