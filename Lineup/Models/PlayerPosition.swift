import Foundation
import SwiftData

@Model
final class PlayerPosition {
    var player: Player?
    var normalizedX: Double   // 0.0 (left) – 1.0 (right)
    var normalizedY: Double   // 0.0 (GK end) – 1.0 (FWD end)

    init(player: Player, normalizedX: Double, normalizedY: Double) {
        self.player = player
        self.normalizedX = normalizedX
        self.normalizedY = normalizedY
    }
}
