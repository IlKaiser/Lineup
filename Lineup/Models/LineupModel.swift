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
}
