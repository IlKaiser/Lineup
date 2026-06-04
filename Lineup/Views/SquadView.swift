import SwiftUI
import SwiftData

struct SquadView: View {
    @Bindable var lineup: LineupModel
    @Query(sort: \Player.number) private var players: [Player]
    @Query private var allLineups: [LineupModel]
    @Environment(\.modelContext) private var modelContext
    @State private var showingAdd = false
    @State private var editingPlayer: Player?

    var body: some View {
        NavigationStack {
            List {
                Section("Shirt Colors") {
                    ColorPicker("Starter Color", selection: Binding(
                        get: { Color(hex: lineup.starterColorHex) },
                        set: { lineup.starterColorHex = $0.toHex() }
                    ))
                    ColorPicker("Bench Color", selection: Binding(
                        get: { Color(hex: lineup.benchColorHex) },
                        set: { lineup.benchColorHex = $0.toHex() }
                    ))
                }
                Section("Players (\(players.count))") {
                    let starterColor = Color(hex: lineup.starterColorHex)
                    ForEach(players) { player in
                        HStack(spacing: 12) {
                            ShirtView(name: "", number: player.number,
                                      color: starterColor, size: 30)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(player.name).font(.body)
                                Text("#\(player.number)").font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture { editingPlayer = player }
                    }
                    .onDelete(perform: deletePlayers)
                }
            }
            .navigationTitle("Squad")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { EditButton() }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showingAdd = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                PlayerEditView(mode: .add).presentationDetents([.medium])
            }
            .sheet(item: $editingPlayer) { player in
                PlayerEditView(mode: .edit(player)).presentationDetents([.medium])
            }
        }
    }

    private func deletePlayers(at offsets: IndexSet) {
        for index in offsets {
            let player = players[index]
            for l in allLineups {
                l.starters
                    .filter { $0.player === player }
                    .forEach { modelContext.delete($0) }
                l.starters.removeAll { $0.player === player }
                l.substitutes.removeAll { $0 === player }
            }
            modelContext.delete(player)
        }
    }
}
