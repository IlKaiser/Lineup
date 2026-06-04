import SwiftUI
import SwiftData

struct LineupDetailView: View {
    @Bindable var lineup: LineupModel
    @Query(sort: \Player.number) private var allPlayers: [Player]
    @State private var showingFormation = false
    @State private var showingShare = false
    @State private var showingAddPlayer = false
    @State private var showingRename = false
    @State private var renameText = ""
    @State private var exportedImage: UIImage?

    /// Players not currently in the starting XI (may be on the bench or unassigned).
    private var availableForStarting: [Player] {
        let starterIDs = Set(lineup.starters.compactMap { $0.player?.id })
        return allPlayers.filter { !starterIDs.contains($0.id) }
    }

    var body: some View {
        VStack(spacing: 0) {
            PitchCanvasView(lineup: lineup)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            BenchStripView(lineup: lineup)
        }
        .navigationTitle(lineup.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { showingFormation = true } label: {
                    Label(lineup.formation, systemImage: "sportscourt")
                        .font(.footnote.weight(.semibold))
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { showingAddPlayer = true } label: {
                    Image(systemName: "person.fill.badge.plus")
                }
                .disabled(lineup.starters.count >= 11)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        renameText = lineup.name
                        showingRename = true
                    } label: {
                        Label("Rename Lineup", systemImage: "pencil")
                    }
                    Button { exportAndShare() } label: {
                        Label("Share as Image", systemImage: "square.and.arrow.up")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingFormation) {
            FormationPickerView(lineup: lineup).presentationDetents([.medium])
        }
        .sheet(isPresented: $showingAddPlayer) {
            PlayerPickerView(players: availableForStarting, title: "Add to Starting XI") { player in
                lineup.addStarter(player)
            }
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $showingShare) {
            if let image = exportedImage {
                ShareSheet(image: image)
            }
        }
        .alert("Rename Lineup", isPresented: $showingRename) {
            TextField("Lineup name", text: $renameText)
            Button("Save") {
                let trimmed = renameText.trimmingCharacters(in: .whitespaces)
                guard !trimmed.isEmpty else { return }
                lineup.name = trimmed
            }
            Button("Cancel", role: .cancel) { }
        }
    }

    private func exportAndShare() {
        guard let image = ImageExporter.export(lineup: lineup) else { return }
        exportedImage = image
        showingShare = true
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let image: UIImage

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [image], applicationActivities: nil)
    }
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}
