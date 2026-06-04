import SwiftUI
import SwiftData

struct DraggableShirtView: View {
    @Bindable var position: PlayerPosition
    let color: Color
    let pitchSize: CGSize
    let onSendToBench: () -> Void

    @State private var dragOffset: CGSize = .zero

    private var displayX: CGFloat {
        position.normalizedX * pitchSize.width + dragOffset.width
    }
    private var displayY: CGFloat {
        position.normalizedY * pitchSize.height + dragOffset.height
    }

    var body: some View {
        if let player = position.player {
            ShirtView(name: player.name, number: player.number, color: color)
                .position(x: displayX, y: displayY)
                .gesture(
                    DragGesture(minimumDistance: 4)
                        .onChanged { value in
                            dragOffset = value.translation
                        }
                        .onEnded { value in
                            let rawX = position.normalizedX * pitchSize.width + value.translation.width
                            let rawY = position.normalizedY * pitchSize.height + value.translation.height
                            position.normalizedX = min(max(rawX / pitchSize.width, 0.03), 0.97)
                            position.normalizedY = min(max(rawY / pitchSize.height, 0.02), 0.98)
                            dragOffset = .zero
                        }
                )
                .contextMenu {
                    Button(role: .destructive, action: onSendToBench) {
                        Label("Send to Bench", systemImage: "arrow.down.circle")
                    }
                }
        }
    }
}
