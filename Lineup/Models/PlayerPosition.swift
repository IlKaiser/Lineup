import Foundation
import SwiftData

@Model
final class PlayerPosition {
    var player: Player?
    var normalizedX: Double
    var normalizedY: Double

    init(player: Player, normalizedX: Double, normalizedY: Double) {
        self.player = player
        self.normalizedX = min(max(normalizedX, 0), 1)
        self.normalizedY = min(max(normalizedY, 0), 1)
    }
}
