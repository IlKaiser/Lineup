import SwiftUI
import SwiftData

struct BenchStripView: View {
    @Bindable var lineup: LineupModel
    @Query(sort: \Player.number) private var allPlayers: [Player]
    @Environment(\.modelContext) private var modelContext
    @State private var showingPicker = false

    private var pickablePlayers: [Player] {
        let starterIDs = Set(lineup.starters.compactMap { $0.player?.id })
        let benchIDs = Set(lineup.substitutes.map { $0.id })
        return allPlayers.filter { !starterIDs.contains($0.id) && !benchIDs.contains($0.id) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Substitutes")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 14)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(lineup.substitutes) { player in
                        ShirtView(name: player.name, number: player.number,
                                  color: Color(hex: lineup.benchColorHex), size: 38)
                            .contextMenu {
                                Button("Move to Starting 11") {
                                    moveToStarting(player)
                                }
                                .disabled(lineup.starters.count >= 11)
                                Button(role: .destructive) {
                                    lineup.substitutes.removeAll { $0.id == player.id }
                                } label: {
                                    Label("Remove from Bench", systemImage: "minus.circle")
                                }
                            }
                    }
                    Button { showingPicker = true } label: {
                        VStack(spacing: 3) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 30))
                                .foregroundStyle(.white.opacity(0.65))
                            Text("Add")
                                .font(.system(size: 9))
                                .foregroundStyle(.white.opacity(0.65))
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
            }
        }
        .padding(.vertical, 6)
        .adaptiveGlass()
        .sheet(isPresented: $showingPicker) {
            PlayerPickerView(players: pickablePlayers) { player in
                lineup.substitutes.append(player)
            }
            .presentationDetents([.medium])
        }
    }

    private func moveToStarting(_ player: Player) {
        guard lineup.starters.count < 11 else { return }
        lineup.substitutes.removeAll { $0 === player }
        let slots = Formations.positions(for: lineup.formation)
        let idx = lineup.starters.count
        let slot = idx < slots.count ? slots[idx] : FormationPosition(x: 0.50, y: 0.50)
        let pos = PlayerPosition(player: player, normalizedX: slot.x, normalizedY: slot.y)
        lineup.starters.append(pos)
    }
}

struct PlayerPickerView: View {
    let players: [Player]
    let onSelect: (Player) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Group {
                if players.isEmpty {
                    ContentUnavailableView(
                        "No Available Players",
                        systemImage: "person.slash",
                        description: Text("All squad members are already on the pitch or bench.")
                    )
                } else {
                    List(players) { player in
                        Button {
                            onSelect(player)
                            dismiss()
                        } label: {
                            HStack(spacing: 12) {
                                Text("\(player.number)")
                                    .font(.headline.monospacedDigit())
                                    .frame(width: 32)
                                Text(player.name)
                                    .foregroundStyle(.primary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add to Bench")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
