import SwiftUI
import SwiftData


extension Array {
    func chunks(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}



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
                .padding(.horizontal, 28)
                .padding(.vertical, 12)

            let benchColor = Color(hex: lineup.benchColorHex)
            let row:[[Player]] = lineup.substitutes.chunks(6)
            ScrollView(.horizontal, showsIndicators: false) {
                VStack{
                    ForEach(0..<row.count, id: \.self){ line in
                        HStack(spacing: 14) {
                            Spacer()
                            ForEach(row[line]) { player in
                                ShirtView(name: player.name, number: player.number,
                                          color: benchColor, size: 38)
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
                            Spacer()
                            
                            if line == row.count - 1{
                          
                                Button { showingPicker = true } label: {
                                    Image(systemName: "plus")
                                        
                                        
                                }
                                .buttonBorderShape(.circle)
                                .buttonStyle(.glassProminent)
                                .tint(.blue)
                            }
                            
                        }.padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        
                    }
                    
                }
               
                
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
