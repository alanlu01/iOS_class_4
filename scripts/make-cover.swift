import AppKit

let width = 1600
let height = 1280
let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0,
                        space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(cgContext: context, flipped: false)
let paper = NSColor(calibratedRed: 0.94, green: 0.92, blue: 0.86, alpha: 1)
let ink = NSColor(calibratedRed: 0.16, green: 0.24, blue: 0.19, alpha: 1)
paper.setFill()
NSBezierPath(rect: NSRect(x: 0, y: 0, width: width, height: height)).fill()
func text(_ value: String, x: Double, y: Double, size: Double, weight: NSFont.Weight = .regular) {
    (value as NSString).draw(at: NSPoint(x: x, y: y), withAttributes: [.font: NSFont.systemFont(ofSize: size, weight: weight), .foregroundColor: ink])
}
text("一杯提案", x: 100, y: 1150, size: 62, weight: .semibold)
text("SIP & SEE", x: 1180, y: 1172, size: 30, weight: .medium)
text("今天，讓偶然替你決定。", x: 104, y: 1104, size: 24)
let files = ["01-home-latte", "03-matcha", "06-favorites"]
for (index, file) in files.enumerated() {
    let image = NSImage(contentsOfFile: "Deliverables/screenshots/\(file).png")!
    let x = 100 + Double(index) * 485
    let rect = NSRect(x: x, y: 110, width: 430, height: 430 * image.size.height / image.size.width)
    NSGraphicsContext.saveGraphicsState()
    NSBezierPath(roundedRect: rect, xRadius: 22, yRadius: 22).addClip()
    image.draw(in: rect)
    NSGraphicsContext.restoreGraphicsState()
}
text("SwiftUI   /   @State   /   Button", x: 100, y: 45, size: 20)
text("iOS CLASS 04", x: 1320, y: 45, size: 17)
NSGraphicsContext.restoreGraphicsState()
context.flush()
let bitmap = NSBitmapImageRep(cgImage: context.makeImage()!)
try bitmap.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: "Deliverables/cover.png"))
