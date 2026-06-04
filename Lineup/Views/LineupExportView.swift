import SwiftUI

/// Static composition used for image export: title, the pitch with starters,
/// and the substitutes laid out in rows. Rendered off-screen by `ImageExporter`.
struct LineupExportView: View {
    let lineup: LineupModel

    private let pitchWidth: CGFloat = 358
    private let pitchHeight: CGFloat = 520

    var body: some View {
        let benchColor = Color(hex: lineup.benchColorHex)
        let subRows = lineup.substitutes.chunks(6)

        VStack(spacing: 16) {
            Text(lineup.name)
                .font(.title.bold())
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.6)

            PitchCanvasView(lineup: lineup)
                .frame(width: pitchWidth, height: pitchHeight)
                .clipShape(RoundedRectangle(cornerRadius: 24))

            if !lineup.substitutes.isEmpty {
                VStack(spacing: 8) {
                    Text("Substitutes")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    ForEach(subRows.indices, id: \.self) { rowIndex in
                        HStack(spacing: 16) {
                            ForEach(subRows[rowIndex]) { player in
                                ShirtView(name: player.name, number: player.number,
                                          color: benchColor, size: 40)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(20)
        .frame(width: pitchWidth + 40)
        .background(Color(.systemBackground))
    }
}
