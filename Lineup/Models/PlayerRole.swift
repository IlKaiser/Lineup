import SwiftUI

/// Soccer player roles (Italian) with a distinct color used to tint bench shirts.
enum PlayerRole: String, CaseIterable, Identifiable {
    case portiere = "Portiere"
    case difensore = "Difensore"
    case centrocampista = "Centrocampista"
    case attaccante = "Attaccante"

    var id: String { rawValue }

    /// Short tag shown in compact contexts (P, D, C, A).
    var abbreviation: String {
        switch self {
        case .portiere: return "P"
        case .difensore: return "D"
        case .centrocampista: return "C"
        case .attaccante: return "A"
        }
    }

    var color: Color {
        switch self {
        case .portiere: return .orange
        case .difensore: return .blue
        case .centrocampista: return .green
        case .attaccante: return .red
        }
    }
}
