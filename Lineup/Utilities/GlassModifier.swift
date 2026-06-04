import SwiftUI

extension View {
    func adaptiveGlass(cornerRadius: CGFloat = 0) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius)
        return Group {
            if #available(iOS 26, *) {
                self.glassEffect(.regular, in: shape)
            } else {
                self.background(.ultraThinMaterial, in: shape)
            }
        }
    }
}
