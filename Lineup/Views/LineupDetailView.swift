import SwiftUI

struct LineupDetailView: View {
    @Bindable var lineup: LineupModel
    @State private var showingFormation = false
    @State private var showingShare = false
    @State private var exportedImage: UIImage?

    var body: some View {
        VStack(spacing: 0) {
            PitchCanvasView(lineup: lineup)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            BenchStripView(lineup: lineup)
        }
        .navigationTitle(lineup.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { showingFormation = true } label: {
                    Label(lineup.formation, systemImage: "sportscourt")
                        .font(.footnote.weight(.semibold))
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { exportAndShare() } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $showingFormation) {
            FormationPickerView(lineup: lineup).presentationDetents([.medium])
        }
        .sheet(isPresented: $showingShare) {
            if let image = exportedImage {
                ShareSheet(image: image)
            }
        }
    }

    private func exportAndShare() {
        guard let image = ImageExporter.export(lineup: lineup) else { return }
        exportedImage = image
        showingShare = true
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let image: UIImage

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [image], applicationActivities: nil)
    }
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}
