import SwiftUI

enum ImageExporter {
    @MainActor
    static func export(lineup: LineupModel) -> UIImage? {
        let view = PitchCanvasView(lineup: lineup)
            .frame(width: 390, height: 600)
        let renderer = ImageRenderer(content: view)
        renderer.scale = 2.0
        return renderer.uiImage
    }
}
