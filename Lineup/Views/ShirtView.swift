import SwiftUI

struct ShirtShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        // Left shoulder → left sleeve
        p.move(to: CGPoint(x: w * 0.22, y: h * 0.22))
        p.addLine(to: CGPoint(x: 0,        y: h * 0.34))
        p.addLine(to: CGPoint(x: 0,        y: h * 0.60))
        p.addLine(to: CGPoint(x: w * 0.22, y: h * 0.54))
        // Body
        p.addLine(to: CGPoint(x: w * 0.22, y: h))
        p.addLine(to: CGPoint(x: w * 0.78, y: h))
        // Right sleeve
        p.addLine(to: CGPoint(x: w * 0.78, y: h * 0.54))
        p.addLine(to: CGPoint(x: w,        y: h * 0.60))
        p.addLine(to: CGPoint(x: w,        y: h * 0.34))
        p.addLine(to: CGPoint(x: w * 0.78, y: h * 0.22))
        // Collar
        p.addLine(to: CGPoint(x: w * 0.64, y: h * 0.08))
        p.addQuadCurve(
            to: CGPoint(x: w * 0.36, y: h * 0.08),
            control: CGPoint(x: w * 0.50, y: h * 0.21)
        )
        p.closeSubpath()
        return p
    }
}

struct ShirtView: View {
    let name: String
    let number: Int
    let color: Color
    var size: CGFloat = 52

    var body: some View {
        VStack(spacing: 2) {
            ZStack {
                ShirtShape()
                    .fill(color)
                    .overlay(ShirtShape().stroke(Color.white.opacity(0.9), lineWidth: 1.5))
                    .frame(width: size, height: size)
                Text("\(number)")
                    .font(.system(size: size * 0.30, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .offset(y: size * 0.08)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(name.isEmpty ? "Number \(number)" : "\(name), number \(number)")
            if !name.isEmpty {
                Text(name)
                    .font(.system(size: max(size * 0.17, 8), weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .fixedSize()
                    .shadow(color: .black.opacity(0.6), radius: 1)
            }
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0.18, green: 0.50, blue: 0.18)
        VStack(spacing: 20) {
            ShirtView(name: "Rossi", number: 9, color: .blue)
            ShirtView(name: "Bianchi", number: 1, color: .red, size: 36)
        }
    }
}
