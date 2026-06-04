import SwiftUI
import SwiftData

struct PitchCanvasView: View {
    @Bindable var lineup: LineupModel
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        GeometryReader { geo in
            let starterColor = Color(hex: lineup.starterColorHex)
            ZStack {
                PitchBackgroundView()
                ForEach(lineup.starters) { position in
                    DraggableShirtView(
                        position: position,
                        color: starterColor,
                        pitchSize: geo.size,
                        onSendToBench: { sendToBench(position) }
                    )
                }
            }
            .clipped()
        }
    }

    private func sendToBench(_ position: PlayerPosition) {
        guard let player = position.player else { return }
        lineup.starters.removeAll { $0 === position }
        modelContext.delete(position)
        if !lineup.substitutes.contains(where: { $0 === player }) {
            lineup.substitutes.append(player)
        }
    }
}
