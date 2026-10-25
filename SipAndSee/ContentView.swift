import SwiftUI

struct ContentView: View {
    @AppStorage("savedDrinks") private var savedDrinks = ""
    @State private var selectedTab = 0
    @State private var flavor: Flavor = .all
    @State private var current = Drink.menu[0]
    @State private var drawCount = 0
    @State private var detail: Drink?

    init() {
        #if DEBUG
        // 只指定起始狀態，截圖仍由真正的 SwiftUI 畫面渲染。
        let arguments = ProcessInfo.processInfo.arguments
        func value(_ key: String) -> String? {
            guard let index = arguments.firstIndex(of: key), arguments.indices.contains(index + 1) else { return nil }
            return arguments[index + 1]
        }
        let drink = Drink.menu.first { $0.id == value("-showDrink") } ?? Drink.menu[0]
        _current = State(initialValue: drink)
        _selectedTab = State(initialValue: Int(value("-showTab") ?? "0") ?? 0)
        _flavor = State(initialValue: Flavor(rawValue: value("-showFlavor") ?? "") ?? .all)
        if arguments.contains("-showRecipe") { _detail = State(initialValue: drink) }
        #endif
    }

    private var savedIDs: Set<String> { Favorites.decode(savedDrinks) }

    var body: some View {
        TabView(selection: $selectedTab) {
            suggestion.tabItem { Label("今日提案", systemImage: "sparkles") }.tag(0)
            collection(savedOnly: false).tabItem { Label("飲品圖鑑", systemImage: "square.grid.2x2") }.tag(1)
            collection(savedOnly: true).tabItem { Label("我的收藏", systemImage: "heart") }.tag(2)
        }
        .tint(Palette.ink)
        .toolbarBackground(Palette.paper, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .sheet(item: $detail) { drink in
            DrinkDetail(drink: drink, isSaved: savedIDs.contains(drink.id)) { toggle(drink) }
        }
    }

    private var suggestion: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Eyebrow(text: "SIP & SEE  /  一杯提案")
                        Spacer()
                        Image(systemName: "cup.and.saucer").font(.system(size: 22, weight: .light))
                    }
                    HStack(alignment: .bottom) {
                        Text("今天，\n想喝點什麼？")
                            .font(.system(size: 34, weight: .semibold, design: .serif)).lineSpacing(3)
                        Spacer()
                        Text("A little sip,\na better day.")
                            .font(.system(size: 17, design: .serif)).italic()
                            .foregroundStyle(Palette.muted).lineSpacing(4).padding(.bottom, 4)
                    }
                    filters
                    hero(height: min(geometry.size.width * 0.70, 300))
                    drinkCaption
                }
                .frame(maxWidth: 550)
                .padding(.horizontal, 24).padding(.top, 18).padding(.bottom, 18)
                .frame(maxWidth: .infinity)
            }
            .safeAreaInset(edge: .bottom, spacing: 0) { drawButton }
            .background(Palette.paper)
        }.foregroundStyle(Palette.ink)
    }

    private var filters: some View {
        HStack(spacing: 8) {
            ForEach(Flavor.allCases) { item in
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        flavor = item
                        if !DrinkPicker.candidates(for: item).contains(current) {
                            current = DrinkPicker.next(for: item, excluding: current.id)
                        }
                    }
                } label: {
                    Text(item.rawValue).font(.system(size: 13, weight: .medium))
                        .frame(maxWidth: .infinity).padding(.vertical, 12)
                        .background(flavor == item ? Palette.ink : Color.clear, in: Capsule())
                        .foregroundStyle(flavor == item ? Palette.paper : Palette.muted)
                        .overlay(Capsule().stroke(flavor == item ? Color.clear : Palette.line))
                }.buttonStyle(.plain).accessibilityIdentifier("filter_\(item.id)")
                    .accessibilityAddTraits(flavor == item ? .isSelected : [])
            }
        }
    }

    private func hero(height: CGFloat) -> some View {
        ZStack(alignment: .top) {
            Image(current.image).resizable().scaledToFill()
                .frame(height: height).clipped()
                .accessibilityLabel(current.name + "飲品照片")
                .accessibilityIdentifier("drinkImage_\(current.id)")
            HStack(alignment: .top) {
                Text("THE DAILY CUP\n\(String(format: "%02d", (Drink.menu.firstIndex(of: current) ?? 0) + 1)) / 03")
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .tracking(1.6).lineSpacing(5)
                Spacer()
                favoriteButton(current)
            }.padding(18)
            VStack { Spacer(); HStack {
                Label(current.temperature, systemImage: current.temperature == "熱飲" ? "sun.max" : "snowflake")
                    .font(.system(size: 11, weight: .medium)).padding(.horizontal, 12).padding(.vertical, 7)
                    .background(Palette.paper.opacity(0.9), in: Capsule())
                Spacer()
                Text("給自己，一杯的時間").font(.system(size: 10)).tracking(2)
            }.padding(18) }
        }.frame(height: height).clipShape(RoundedRectangle(cornerRadius: 7))
    }

    private var drinkCaption: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(current.name).font(.system(size: 27, weight: .semibold, design: .serif))
                    .accessibilityIdentifier("currentDrinkName")
                Spacer()
                Button { detail = current } label: {
                    HStack(spacing: 4) { Text("杯中筆記"); Image(systemName: "arrow.up.right") }
                        .font(.system(size: 12, weight: .medium)).foregroundStyle(Palette.accent)
                }.accessibilityIdentifier("detailButton")
            }
            Text(current.english.uppercased()).font(.system(size: 10, design: .monospaced))
                .tracking(2).foregroundStyle(Palette.muted)
            Text(current.description).font(.system(size: 13)).lineSpacing(5)
                .foregroundStyle(Palette.muted).padding(.top, 4).fixedSize(horizontal: false, vertical: true)
        }
    }

    private var drawButton: some View {
        let single = DrinkPicker.candidates(for: flavor).count == 1
        return VStack(spacing: 9) {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    current = DrinkPicker.next(for: flavor, excluding: current.id)
                    drawCount += 1
                }
            } label: {
                HStack {
                    Image(systemName: "shuffle")
                    Spacer()
                    Text(single ? "這杯就是你的清爽提案" : "幫我選一杯").tracking(2)
                    Spacer()
                    Image(systemName: "arrow.right")
                }.font(.system(size: 15, weight: .medium))
                    .padding(.horizontal, 22).frame(height: 53)
                    .background(Palette.ink.opacity(single ? 0.65 : 1), in: RoundedRectangle(cornerRadius: 6))
                    .foregroundStyle(Palette.paper)
            }.buttonStyle(.plain).disabled(single).accessibilityIdentifier("drawButton")
            Text(single ? "這個風味目前有 1 杯，試試其他風味吧" :
                    (drawCount == 0 ? "3 杯日常靈感，讓偶然替你決定" : "第 \(drawCount) 次靈感 · 每次都與上一杯不同"))
                .font(.system(size: 10)).foregroundStyle(Palette.muted)
                .accessibilityIdentifier("drawStatus")
        }.frame(maxWidth: 550).padding(.horizontal, 24).padding(.top, 12).padding(.bottom, 10)
            .frame(maxWidth: .infinity).background(Palette.paper)
    }

    private func collection(savedOnly: Bool) -> some View {
        let drinks = Drink.menu.filter { !savedOnly || savedIDs.contains($0.id) }
        return ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                PageHeader(title: savedOnly ? "留住喜歡的味道。" : "每一杯，都有個性。",
                           subtitle: savedOnly ? "收藏 \(drinks.count) 杯，留給下次的自己。" : "三種風味，三種剛剛好的日常。")
                if drinks.isEmpty {
                    VStack(spacing: 18) {
                        Image(systemName: "heart").font(.system(size: 44, weight: .ultraLight))
                        Text("還在等一杯心動").font(.title3)
                        Text("在飲品照片上點一下愛心，\n喜歡的味道就會留在這裡。")
                            .font(.subheadline).multilineTextAlignment(.center).foregroundStyle(Palette.muted)
                        Button { selectedTab = 0 } label: {
                            Text("去找一杯靈感").foregroundStyle(Palette.paper)
                        }.buttonStyle(.borderedProminent).tint(Palette.ink)
                    }.frame(maxWidth: .infinity).padding(.vertical, 90)
                }
                ForEach(drinks) { drink in
                    VStack(alignment: .leading, spacing: 12) {
                        ZStack(alignment: .topTrailing) {
                            Button { detail = drink } label: {
                                Image(drink.image).resizable().scaledToFill()
                                    .frame(height: 220).clipped()
                            }.buttonStyle(.plain).accessibilityIdentifier("card_\(drink.id)")
                            favoriteButton(drink).padding(12)
                        }.clipShape(RoundedRectangle(cornerRadius: 7))
                        HStack {
                            Text(drink.name).font(.system(size: 23, weight: .semibold, design: .serif))
                            Spacer()
                            Text(drink.temperature).font(.caption).foregroundStyle(Palette.muted)
                        }
                        Text(drink.note).font(.system(size: 12)).foregroundStyle(Palette.muted)
                    }
                }
                Text("SLOW DOWN. SIP SOMETHING GOOD.")
                    .font(.system(size: 9, design: .monospaced)).tracking(1.5)
                    .foregroundStyle(Palette.muted).frame(maxWidth: .infinity).padding(.vertical, 12)
            }.frame(maxWidth: 550).padding(24).frame(maxWidth: .infinity)
        }.background(Palette.paper).foregroundStyle(Palette.ink)
    }

    private func favoriteButton(_ drink: Drink) -> some View {
        Button { toggle(drink) } label: {
            Image(systemName: savedIDs.contains(drink.id) ? "heart.fill" : "heart")
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(savedIDs.contains(drink.id) ? Palette.accent : Palette.ink)
                .frame(width: 44, height: 44).background(Palette.paper.opacity(0.94), in: Circle())
        }.buttonStyle(.plain).accessibilityLabel(savedIDs.contains(drink.id) ? "取消收藏\(drink.name)" : "收藏\(drink.name)")
            .accessibilityIdentifier("favorite_\(drink.id)")
    }

    private func toggle(_ drink: Drink) { savedDrinks = Favorites.toggled(drink.id, in: savedDrinks) }
}

#Preview { ContentView() }
