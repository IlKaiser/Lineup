import Foundation
import SwiftData

@Model
final class LineupModel {
    var name: String
    var formation: String
    var starterColorHex: String
    var benchColorHex: String
    var createdAt: Date
    @Relationship(deleteRule: .cascade) var starters: [PlayerPosition]
    @Relationship(deleteRule: .noAction) var substitutes: [Player]

    init(name: String = "New Lineup",
         formation: String = "4-3-3",
         starterColorHex: String = "#3498DB",
         benchColorHex: String = "#E67E22") {
        self.name = name
        self.formation = formation
        self.starterColorHex = starterColorHex
        self.benchColorHex = benchColorHex
        self.createdAt = Date()
        self.starters = []
        self.substitutes = []
    }

    /// Places a player into the next open formation slot of the starting XI.
    /// Removes the player from the bench first. No-op if the XI is already full.
    func addStarter(_ player: Player) {
        guard starters.count < 11 else { return }
        substitutes.removeAll { $0 === player }
        let slots = Formations.positions(for: formation)
        let index = starters.count
        let slot = index < slots.count ? slots[index] : FormationPosition(x: 0.50, y: 0.50)
        starters.append(PlayerPosition(player: player, normalizedX: slot.x, normalizedY: slot.y))
    }
}
