import Foundation
import SwiftData

@Model
final class PlayerPosition {
    var player: Player?
    var normalizedX: Double
    var normalizedY: Double

    init(player: Player, normalizedX: Double, normalizedY: Double) {
        self.player = player
        self.normalizedX = normalizedX
        self.normalizedY = normalizedY
    }
}
