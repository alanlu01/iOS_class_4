import AppKit

let size = NSSize(width: 1024, height: 1024)
let context = CGContext(data: nil, width: 1024, height: 1024, bitsPerComponent: 8, bytesPerRow: 0,
                        space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(cgContext: context, flipped: false)
NSColor(calibratedRed: 0.16, green: 0.24, blue: 0.19, alpha: 1).setFill()
NSBezierPath(rect: NSRect(origin: .zero, size: size)).fill()
let cream = NSColor(calibratedRed: 0.97, green: 0.95, blue: 0.90, alpha: 1)
cream.setStroke()
let handle = NSBezierPath(ovalIn: NSRect(x: 614, y: 350, width: 176, height: 190))
handle.lineWidth = 38
handle.stroke()
cream.setFill()
let cup = NSBezierPath(roundedRect: NSRect(x: 252, y: 286, width: 424, height: 315), xRadius: 76, yRadius: 76)
cup.fill()
NSColor(calibratedRed: 0.62, green: 0.36, blue: 0.21, alpha: 1).setFill()
NSBezierPath(ovalIn: NSRect(x: 285, y: 548, width: 358, height: 56)).fill()
cream.setStroke()
let saucer = NSBezierPath()
saucer.move(to: NSPoint(x: 220, y: 232)); saucer.line(to: NSPoint(x: 744, y: 232))
saucer.lineWidth = 26; saucer.lineCapStyle = .round; saucer.stroke()
for x in [396.0, 492.0, 588.0] {
    let steam = NSBezierPath()
    steam.move(to: NSPoint(x: x, y: 670))
    steam.curve(to: NSPoint(x: x, y: 812), controlPoint1: NSPoint(x: x - 60, y: 727), controlPoint2: NSPoint(x: x + 60, y: 754))
    steam.lineWidth = 17; steam.lineCapStyle = .round; steam.stroke()
}
NSGraphicsContext.restoreGraphicsState()
context.flush()
let bitmap = NSBitmapImageRep(cgImage: context.makeImage()!)
try bitmap.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: CommandLine.arguments[1]))
