import SwiftUI

extension View {
    func adaptiveGlass() -> some View {
        Group {
            if #available(iOS 26, *) {
                self.glassEffect()
            } else {
                self.background(.ultraThinMaterial)
            }
        }
    }
}
