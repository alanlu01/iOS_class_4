import SwiftUI

enum Palette {
    static let paper = Color(red: 0.97, green: 0.95, blue: 0.90)
    static let ink = Color(red: 0.16, green: 0.24, blue: 0.19)
    static let muted = Color(red: 0.43, green: 0.46, blue: 0.40)
    static let line = Color(red: 0.86, green: 0.85, blue: 0.79)
    static let accent = Color(red: 0.72, green: 0.36, blue: 0.20)
}

struct Eyebrow: View {
    let text: String
    var body: some View {
        Text(text).font(.system(size: 10, weight: .semibold, design: .monospaced))
            .tracking(2.4).foregroundStyle(Palette.muted)
    }
}

struct PageHeader: View {
    let title: String
    let subtitle: String
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Eyebrow(text: "SIP & SEE  /  一杯提案")
            Text(title).font(.system(size: 32, weight: .semibold, design: .serif))
            Text(subtitle).font(.subheadline).foregroundStyle(Palette.muted)
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}
