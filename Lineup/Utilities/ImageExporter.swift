import SwiftUI

enum ImageExporter {
    @MainActor
    static func export(lineup: LineupModel) -> UIImage? {
        let renderer = ImageRenderer(content: LineupExportView(lineup: lineup))
        renderer.scale = 3.0
        return renderer.uiImage
    }
}
