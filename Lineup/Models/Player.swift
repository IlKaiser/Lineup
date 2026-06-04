import Foundation
import SwiftData

@Model
final class Player {
    var name: String
    var number: Int
    /// Stored as the PlayerRole raw value. Default enables lightweight migration
    /// of players created before roles existed.
    var role: String = PlayerRole.centrocampista.rawValue

    init(name: String, number: Int, role: PlayerRole = .centrocampista) {
        self.name = name
        self.number = number
        self.role = role.rawValue
    }

    var playerRole: PlayerRole {
        get { PlayerRole(rawValue: role) ?? .centrocampista }
        set { role = newValue.rawValue }
    }
}
