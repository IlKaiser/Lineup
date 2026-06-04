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
                }
            }
        }
    }

    private func save() {
        guard let number = Int(numberText), (1...99).contains(number) else { return }
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        switch mode {
        case .add:
            modelContext.insert(Player(name: trimmed, number: number))
        case .edit(let player):
            player.name = trimmed
            player.number = number
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
