import SwiftUI
import SwiftData

struct PlayerEditView: View {
    enum Mode {
        case add
        case edit(Player)
    }

    let mode: Mode
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var numberText = ""
    @State private var role: PlayerRole = .centrocampista

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        (1...99).contains(Int(numberText) ?? 0)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Player Info") {
                    TextField("Name", text: $name)
                    TextField("Number (1–99)", text: $numberText)
                        .keyboardType(.numberPad)
                    Picker("Role", selection: $role) {
                        ForEach(PlayerRole.allCases) { r in
                            HStack {
                                Circle().fill(r.color).frame(width: 12, height: 12)
                                Text(r.rawValue)
                            }
                            .tag(r)
                        }
                    }
                }
            }
            .navigationTitle(mode.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save).disabled(!isValid)
                }
            }
            .onAppear {
                if case .edit(let player) = mode {
                    name = player.name
                    numberText = "\(player.number)"
                    role = player.playerRole
                }
            }
        }
    }

    private func save() {
        guard let number = Int(numberText), (1...99).contains(number) else { return }
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        switch mode {
        case .add:
            modelContext.insert(Player(name: trimmed, number: number, role: role))
        case .edit(let player):
            player.name = trimmed
            player.number = number
            player.playerRole = role
        }
        dismiss()
    }
}

private extension PlayerEditView.Mode {
    var title: String {
        switch self {
        case .add: "New Player"
        case .edit: "Edit Player"
        }
    }
}
