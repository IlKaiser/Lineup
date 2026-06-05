import SwiftUI
import SwiftData


extension Array {
    func chunks(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}

/// Reports each bench shirt's frame (in the bench coordinate space) so a drag
/// can detect which shirt it is dropped onto.
private struct BenchFramesKey: PreferenceKey {
    static var defaultValue: [Player.ID: CGRect] { [:] }
    static func reduce(value: inout [Player.ID: CGRect], nextValue: () -> [Player.ID: CGRect]) {
        value.merge(nextValue()) { $1 }
    }
}

struct BenchStripView: View {
    @Bindable var lineup: LineupModel
    @Query(sort: \Player.number) private var allPlayers: [Player]
    @Environment(\.modelContext) private var modelContext
    @State private var showingPicker = false

    @State private var frames: [Player.ID: CGRect] = [:]
    @State private var draggingID: Player.ID?
    @State private var dragOffset: CGSize = .zero

    private let coordSpace = "benchSpace"

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
                .padding(.horizontal, 28)
                .padding(.vertical, 12)

            benchRows
                .coordinateSpace(name: coordSpace)
                .onPreferenceChange(BenchFramesKey.self) { newFrames in
                    // Freeze frame measurements while dragging so the dragged
                    // shirt's offset doesn't corrupt the stored positions.
                    if draggingID == nil { frames = newFrames }
                }
        }
        .adaptiveGlass(cornerRadius: 20)
        .padding(.horizontal, 12)
        .padding(.bottom, 8)
        .sheet(isPresented: $showingPicker) {
            PlayerPickerView(players: pickablePlayers) { player in
                lineup.substitutes.append(player)
            }
            .presentationDetents([.medium])
        }
    }

    private var benchRows: some View {
        let rows = lineup.substitutes.chunks(6)
        return VStack(spacing: 6) {
            if rows.isEmpty {
                HStack {
                    Spacer()
                    addButton
                    Spacer()
                }
                .padding(.vertical, 2)
            } else {
                ForEach(rows.indices, id: \.self) { line in
                    HStack(spacing: 14) {
                        Spacer()
                        ForEach(rows[line]) { player in
                            shirt(for: player)
                        }
                        Spacer()
                        if line == rows.count - 1 {
                            addButton
                        }
                    }
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                }
            }
        }
    }

    private func shirt(for player: Player) -> some View {
        ShirtView(name: player.name, number: player.number,
                  color: player.playerRole.color, size: 38)
            .offset(draggingID == player.id ? dragOffset : .zero)
            .scaleEffect(draggingID == player.id ? 1.1 : 1.0)
            .zIndex(draggingID == player.id ? 1 : 0)
            .background(
                GeometryReader { geo in
                    Color.clear.preference(
                        key: BenchFramesKey.self,
                        value: [player.id: geo.frame(in: .named(coordSpace))]
                    )
                }
            )
            .gesture(reorderGesture(for: player))
            .contextMenu {
                Button("Move to Starting 11") { moveToStarting(player) }
                    .disabled(lineup.starters.count >= 11)
                Button(role: .destructive) {
                    lineup.substitutes.removeAll { $0.id == player.id }
                } label: {
                    Label("Remove from Bench", systemImage: "minus.circle")
                }
            }
    }

    private var addButton: some View {
        Button { showingPicker = true } label: {
            Image(systemName: "plus")
        }
        .buttonBorderShape(.circle)
        .buttonStyle(.glassProminent)
        .tint(.blue)
    }

    /// Fast pick-up (0.12s) then drag; on release, swaps with the overlapped shirt.
    private func reorderGesture(for player: Player) -> some Gesture {
        LongPressGesture(minimumDuration: 0.12)
            .sequenced(before: DragGesture(coordinateSpace: .named(coordSpace)))
            .onChanged { value in
                if case .second(true, let drag) = value {
                    draggingID = player.id
                    dragOffset = drag?.translation ?? .zero
                }
            }
            .onEnded { value in
                defer {
                    withAnimation(.snappy(duration: 0.2)) {
                        draggingID = nil
                        dragOffset = .zero
                    }
                }
                guard case .second(true, let drag?) = value,
                      let start = frames[player.id] else { return }
                let point = CGPoint(x: start.midX + drag.translation.width,
                                    y: start.midY + drag.translation.height)
                guard let targetID = frames.first(where: { $0.key != player.id && $0.value.contains(point) })?.key,
                      let from = lineup.substitutes.firstIndex(where: { $0.id == player.id }),
                      let to = lineup.substitutes.firstIndex(where: { $0.id == targetID }) else { return }
                lineup.substitutes.swapAt(from, to)
            }
    }

    private func moveToStarting(_ player: Player) {
        lineup.addStarter(player)
    }
}

struct PlayerPickerView: View {
    let players: [Player]
    var title: String = "Add to Bench"
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
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
