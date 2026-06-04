import SwiftUI

struct PitchBackgroundView: View {
    var body: some View {
        Canvas { ctx, size in
            let w = size.width, h = size.height

            ctx.fill(Path(CGRect(origin: .zero, size: size)),
                     with: .color(Color(red: 0.18, green: 0.50, blue: 0.18)))

            func stroke(_ path: Path, width: CGFloat = 1.5) {
                ctx.stroke(path, with: .color(.white.opacity(0.80)), lineWidth: width)
            }

            // Boundary
            stroke(Path(CGRect(x: w*0.03, y: h*0.02, width: w*0.94, height: h*0.96)), width: 2)
            // Halfway line
            var mid = Path()
            mid.move(to: CGPoint(x: w*0.03, y: h*0.50))
            mid.addLine(to: CGPoint(x: w*0.97, y: h*0.50))
            stroke(mid)
            // Centre circle
            stroke(Path(ellipseIn: CGRect(x: w*0.30, y: h*0.37, width: w*0.40, height: h*0.26)))
            // Centre spot
            ctx.fill(Path(ellipseIn: CGRect(x: w*0.484, y: h*0.488,
                                            width: w*0.032, height: h*0.024)),
                     with: .color(.white.opacity(0.80)))
            // Top penalty area
            stroke(Path(CGRect(x: w*0.22, y: h*0.02, width: w*0.56, height: h*0.22)))
            // Top goal area
            stroke(Path(CGRect(x: w*0.36, y: h*0.02, width: w*0.28, height: h*0.09)))
            // Bottom penalty area
            stroke(Path(CGRect(x: w*0.22, y: h*0.76, width: w*0.56, height: h*0.22)))
            // Bottom goal area
            stroke(Path(CGRect(x: w*0.36, y: h*0.89, width: w*0.28, height: h*0.09)))
        }
    }
}

#Preview {
    PitchBackgroundView()
        .frame(width: 320, height: 480)
        .ignoresSafeArea()
}
