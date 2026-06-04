import SwiftUI
import SwiftData

struct PitchCanvasView: View {
    @Bindable var lineup: LineupModel
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        GeometryReader { geo in
            ZStack {
                PitchBackgroundView()
                ForEach(lineup.starters) { position in
                    DraggableShirtView(
                        position: position,
                        color: Color(hex: lineup.starterColorHex),
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
        lineup.starters.removeAll { $0.id == position.id }
        modelContext.delete(position)
        if !lineup.substitutes.contains(where: { $0.id == player.id }) {
            lineup.substitutes.append(player)
        }
    }
}
