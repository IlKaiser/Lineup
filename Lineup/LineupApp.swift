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

    var body: some View {
        if sizeClass == .regular {
            IPadRootView()
        } else {
            IPhoneRootView()
        }
    }
}

// MARK: - iPhone Layout

struct IPhoneRootView: View {
    @Query(sort: \LineupModel.createdAt) private var lineups: [LineupModel]
    @Environment(\.modelContext) private var modelContext
    @State private var selectedLineup: LineupModel?

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
        .onAppear { ensureDefaultLineup() }
    }

    private func ensureDefaultLineup() {
        if lineups.isEmpty {
            let lineup = LineupModel(name: "My Lineup")
            modelContext.insert(lineup)
            selectedLineup = lineup
        } else if selectedLineup == nil {
            selectedLineup = lineups.first
        }
    }
}

// MARK: - iPad Layout

struct IPadRootView: View {
    @Query(sort: \LineupModel.createdAt) private var lineups: [LineupModel]
    @Environment(\.modelContext) private var modelContext
    @State private var selectedLineup: LineupModel?
    @State private var columnVisibility = NavigationSplitViewVisibility.all

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
        .onAppear { ensureDefaultLineup() }
    }

    private func ensureDefaultLineup() {
        if lineups.isEmpty {
            let lineup = LineupModel(name: "My Lineup")
            modelContext.insert(lineup)
            selectedLineup = lineup
        } else if selectedLineup == nil {
            selectedLineup = lineups.first
        }
    }
}
