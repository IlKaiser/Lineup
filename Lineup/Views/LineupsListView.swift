import SwiftUI
import SwiftData

struct LineupsListView: View {
    @Query(sort: \LineupModel.createdAt) private var lineups: [LineupModel]
    @Environment(\.modelContext) private var modelContext
    @State private var showingNewLineup = false
    @State private var newLineupName = ""
    @State private var renamingLineup: LineupModel?
    @State private var renameText = ""
    @Binding var selectedLineup: LineupModel?

    var body: some View {
        List(selection: $selectedLineup) {
            ForEach(lineups) { lineup in
                NavigationLink(value: lineup) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(lineup.name).font(.headline)
                        Text(lineup.formation).font(.caption).foregroundStyle(.secondary)
                    }
                }
                .contextMenu {
                    Button("Rename") {
                        renameText = lineup.name
                        renamingLineup = lineup
                    }
                    Button(role: .destructive) {
                        modelContext.delete(lineup)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .onDelete { offsets in
                offsets.map { lineups[$0] }.forEach { modelContext.delete($0) }
            }
        }
        .navigationTitle("Lineups")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) { EditButton() }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { showingNewLineup = true } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .alert("New Lineup", isPresented: $showingNewLineup) {
            TextField("Name (e.g. vs Roma)", text: $newLineupName)
            Button("Create") { createLineup() }
            Button("Cancel", role: .cancel) { newLineupName = "" }
        }
        .alert("Rename", isPresented: Binding(
            get: { renamingLineup != nil },
            set: { if !$0 { renamingLineup = nil } }
        )) {
            TextField("Lineup name", text: $renameText)
            Button("Save") {
                renamingLineup?.name = renameText
                renamingLineup = nil
            }
            Button("Cancel", role: .cancel) { renamingLineup = nil }
        }
    }

    private func createLineup() {
        guard !newLineupName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let lineup = LineupModel(name: newLineupName.trimmingCharacters(in: .whitespaces))
        modelContext.insert(lineup)
        newLineupName = ""
        selectedLineup = lineup
    }
}
