import SwiftUI

struct FormationPickerView: View {
    @Bindable var lineup: LineupModel
    @Environment(\.dismiss) private var dismiss

    private let formationNames = [
        "4-4-2", "4-3-3", "4-2-3-1",
        "3-5-2", "3-4-3", "5-3-2",
        "4-5-1", "5-4-1", "4-1-4-1"
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3),
                    spacing: 10
                ) {
                    ForEach(formationNames, id: \.self) { name in
                        let isActive = lineup.formation == name
                        Button { applyFormation(name) } label: {
                            Text(name)
                                .font(.system(size: 15, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(isActive ? Color.blue.opacity(0.20) : Color(uiColor: .secondarySystemFill))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(isActive ? Color.blue : Color.clear, lineWidth: 1.5)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .foregroundStyle(isActive ? .blue : .primary)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Formation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private func applyFormation(_ name: String) {
        lineup.formation = name
        let positions = Formations.positions(for: name)
        for (index, starter) in lineup.starters.enumerated() {
            guard index < positions.count else { break }
            starter.normalizedX = positions[index].x
            starter.normalizedY = positions[index].y
        }
        dismiss()
    }
}
