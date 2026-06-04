import SwiftUI
import SwiftData

@main
struct LineupApp: App {
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(
                for: Player.self, PlayerPosition.self, LineupModel.self
            )
        } catch {
            fatalError("ModelContainer init failed: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(container)
        }
    }
}

struct RootView: View {
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Environment(\.modelContext) private var modelContext
    @State private var selectedLineup: LineupModel?
    @State private var columnVisibility = NavigationSplitViewVisibility.all

    var body: some View {
        Group {
            if sizeClass == .regular {
                IPadRootView(selectedLineup: $selectedLineup, columnVisibility: $columnVisibility)
            } else {
                IPhoneRootView(selectedLineup: $selectedLineup)
            }
        }
        .task { ensureDefaultLineup() }
    }

    private func ensureDefaultLineup() {
        var descriptor = FetchDescriptor<LineupModel>()
        descriptor.fetchLimit = 1
        let existing = (try? modelContext.fetch(descriptor)) ?? []
        if existing.isEmpty {
            let lineup = LineupModel(name: "My Lineup")
            modelContext.insert(lineup)
            selectedLineup = lineup
        } else if selectedLineup == nil {
            selectedLineup = existing.first
        }
    }
}

// MARK: - iPhone Layout

struct IPhoneRootView: View {
    @Binding var selectedLineup: LineupModel?
    @Query(sort: \LineupModel.createdAt) private var lineups: [LineupModel]

    var body: some View {
        TabView {
            NavigationStack {
                LineupsListView(selectedLineup: $selectedLineup)
                    .navigationDestination(for: LineupModel.self) { lineup in
                        LineupDetailView(lineup: lineup)
                    }
            }
            .tabItem { Label("Lineups", systemImage: "sportscourt.fill") }

            Group {
                if let lineup = selectedLineup ?? lineups.first {
                    SquadView(lineup: lineup)
                } else {
                    ContentUnavailableView("No Lineup", systemImage: "sportscourt",
                                          description: Text("Create a lineup first."))
                }
            }
            .tabItem { Label("Squad", systemImage: "person.3.fill") }
        }
    }
}

// MARK: - iPad Layout

struct IPadRootView: View {
    @Binding var selectedLineup: LineupModel?
    @Binding var columnVisibility: NavigationSplitViewVisibility

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            LineupsListView(selectedLineup: $selectedLineup)
        } detail: {
            if let lineup = selectedLineup {
                LineupDetailView(lineup: lineup)
            } else {
                ContentUnavailableView("Select a Lineup", systemImage: "sportscourt",
                                      description: Text("Choose a lineup from the sidebar."))
            }
        }
    }
}
