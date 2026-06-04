struct FormationPosition {
    let x: Double
    let y: Double
}

enum Formations {
    static let all: [String: [FormationPosition]] = [
        "4-4-2": [
            .init(x: 0.50, y: 0.05),
            .init(x: 0.15, y: 0.27), .init(x: 0.38, y: 0.27),
            .init(x: 0.62, y: 0.27), .init(x: 0.85, y: 0.27),
            .init(x: 0.15, y: 0.54), .init(x: 0.38, y: 0.54),
            .init(x: 0.62, y: 0.54), .init(x: 0.85, y: 0.54),
            .init(x: 0.35, y: 0.80), .init(x: 0.65, y: 0.80)
        ],
        "4-3-3": [
            .init(x: 0.50, y: 0.05),
            .init(x: 0.15, y: 0.27), .init(x: 0.38, y: 0.27),
            .init(x: 0.62, y: 0.27), .init(x: 0.85, y: 0.27),
            .init(x: 0.25, y: 0.54), .init(x: 0.50, y: 0.54), .init(x: 0.75, y: 0.54),
            .init(x: 0.15, y: 0.80), .init(x: 0.50, y: 0.80), .init(x: 0.85, y: 0.80)
        ],
        "4-2-3-1": [
            .init(x: 0.50, y: 0.05),
            .init(x: 0.15, y: 0.24), .init(x: 0.38, y: 0.24),
            .init(x: 0.62, y: 0.24), .init(x: 0.85, y: 0.24),
            .init(x: 0.33, y: 0.45), .init(x: 0.67, y: 0.45),
            .init(x: 0.15, y: 0.64), .init(x: 0.50, y: 0.64), .init(x: 0.85, y: 0.64),
            .init(x: 0.50, y: 0.84)
        ],
        "3-5-2": [
            .init(x: 0.50, y: 0.05),
            .init(x: 0.25, y: 0.26), .init(x: 0.50, y: 0.26), .init(x: 0.75, y: 0.26),
            .init(x: 0.10, y: 0.52), .init(x: 0.30, y: 0.52), .init(x: 0.50, y: 0.52),
            .init(x: 0.70, y: 0.52), .init(x: 0.90, y: 0.52),
            .init(x: 0.35, y: 0.80), .init(x: 0.65, y: 0.80)
        ],
        "3-4-3": [
            .init(x: 0.50, y: 0.05),
            .init(x: 0.25, y: 0.26), .init(x: 0.50, y: 0.26), .init(x: 0.75, y: 0.26),
            .init(x: 0.15, y: 0.52), .init(x: 0.38, y: 0.52),
            .init(x: 0.62, y: 0.52), .init(x: 0.85, y: 0.52),
            .init(x: 0.15, y: 0.80), .init(x: 0.50, y: 0.80), .init(x: 0.85, y: 0.80)
        ],
        "5-3-2": [
            .init(x: 0.50, y: 0.05),
            .init(x: 0.10, y: 0.26), .init(x: 0.30, y: 0.26), .init(x: 0.50, y: 0.26),
            .init(x: 0.70, y: 0.26), .init(x: 0.90, y: 0.26),
            .init(x: 0.25, y: 0.54), .init(x: 0.50, y: 0.54), .init(x: 0.75, y: 0.54),
            .init(x: 0.35, y: 0.80), .init(x: 0.65, y: 0.80)
        ],
        "4-5-1": [
            .init(x: 0.50, y: 0.05),
            .init(x: 0.15, y: 0.26), .init(x: 0.38, y: 0.26),
            .init(x: 0.62, y: 0.26), .init(x: 0.85, y: 0.26),
            .init(x: 0.10, y: 0.54), .init(x: 0.30, y: 0.54), .init(x: 0.50, y: 0.54),
            .init(x: 0.70, y: 0.54), .init(x: 0.90, y: 0.54),
            .init(x: 0.50, y: 0.82)
        ],
        "5-4-1": [
            .init(x: 0.50, y: 0.05),
            .init(x: 0.10, y: 0.26), .init(x: 0.30, y: 0.26), .init(x: 0.50, y: 0.26),
            .init(x: 0.70, y: 0.26), .init(x: 0.90, y: 0.26),
            .init(x: 0.15, y: 0.54), .init(x: 0.38, y: 0.54),
            .init(x: 0.62, y: 0.54), .init(x: 0.85, y: 0.54),
            .init(x: 0.50, y: 0.82)
        ],
        "4-1-4-1": [
            .init(x: 0.50, y: 0.05),
            .init(x: 0.15, y: 0.23), .init(x: 0.38, y: 0.23),
            .init(x: 0.62, y: 0.23), .init(x: 0.85, y: 0.23),
            .init(x: 0.50, y: 0.41),
            .init(x: 0.15, y: 0.59), .init(x: 0.38, y: 0.59),
            .init(x: 0.62, y: 0.59), .init(x: 0.85, y: 0.59),
            .init(x: 0.50, y: 0.82)
        ]
    ]

    static func positions(for formation: String) -> [FormationPosition] {
        return all[formation] ?? all["4-3-3"] ?? []
    }
}
