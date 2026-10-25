import SwiftUI

struct DrinkDetail: View {
    let drink: Drink
    let isSaved: Bool
    let toggleFavorite: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 23) {
                    Image(drink.image).resizable().scaledToFill().frame(height: 260).clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 7))
                    VStack(alignment: .leading, spacing: 8) {
                        Eyebrow(text: drink.english.uppercased())
                        Text(drink.name).font(.system(size: 32, weight: .semibold, design: .serif))
                        Text(drink.note).font(.subheadline).foregroundStyle(Palette.muted)
                    }
                    Text(drink.description).font(.subheadline).lineSpacing(6).foregroundStyle(Palette.muted)
                    Divider()
                    VStack(alignment: .leading, spacing: 12) {
                        Text("杯裡的配方").font(.headline)
                        ForEach(drink.ingredients, id: \.self) { Text($0).font(.subheadline) }
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        Text("動手做一杯").font(.headline)
                        ForEach(Array(drink.steps.enumerated()), id: \.offset) { index, step in
                            HStack(alignment: .top, spacing: 12) {
                                Text(String(format: "%02d", index + 1)).font(.system(.caption, design: .monospaced))
                                    .foregroundStyle(Palette.accent)
                                Text(step).font(.subheadline).fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    Button(action: toggleFavorite) {
                        Label(isSaved ? "已收藏這杯" : "收藏這杯", systemImage: isSaved ? "heart.fill" : "heart")
                            .frame(maxWidth: .infinity).padding(10)
                            .foregroundStyle(Palette.paper)
                    }.buttonStyle(.borderedProminent).tint(Palette.ink).accessibilityIdentifier("detailFavorite")
                    Text("配方為一人份靈感，可依喜好調整濃淡。")
                        .font(.caption).foregroundStyle(Palette.muted)
                }.frame(maxWidth: 550).padding(24).frame(maxWidth: .infinity)
            }.background(Palette.paper).foregroundStyle(Palette.ink)
                .navigationTitle("杯中筆記").navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Palette.paper, for: .navigationBar)
                .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("完成") { dismiss() }.tint(Palette.ink) } }
        }
    }
}
