import PDFKit
import SwiftUI
import UIKit

struct NativeMapView: View {
    @State private var selectedMapStation: Station? = nil

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZoomableMapScrollView(
                    viewSize: geometry.size,
                    selectedStation: $selectedMapStation
                )
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle("System Map")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $selectedMapStation) { station in
                StationDetailView(station: station)
            }
        }
    }
}

struct ZoomableMapScrollView: UIViewRepresentable {
    let viewSize: CGSize
    @Binding var selectedStation: Station?

    func renderPDF(document: PDFDocument, scale: CGFloat = 3.0) -> UIImage? {
        guard let page = document.page(at: 0), let pageRef = page.pageRef else { return nil }

        let targetSize = CGSize(width: 2000, height: 1718)
        let pixelWidth = Int(targetSize.width * scale)
        let pixelHeight = Int(targetSize.height * scale)

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1.0 // Render explicitly at pixel coordinates

        let renderer = UIGraphicsImageRenderer(size: CGSize(width: pixelWidth, height: pixelHeight), format: format)
        return renderer.image { context in
            let cgContext = context.cgContext

            // Fill background with white
            cgContext.setFillColor(UIColor.white.cgColor)
            cgContext.fill(CGRect(x: 0, y: 0, width: pixelWidth, height: pixelHeight))

            // Flip coordinates for Y-up PDF rendering
            cgContext.translateBy(x: 0, y: CGFloat(pixelHeight))
            cgContext.scaleBy(x: 1.0, y: -1.0)

            // Scale to match target size (2000x1718) and resolution multiplier
            cgContext.scaleBy(x: 1.92 * scale, y: 1.92 * scale)

            // Translate to the bottom-left of the crop box in PDF points
            cgContext.translateBy(x: -16.6667, y: -133.875)

            cgContext.drawPDFPage(pageRef)
        }
    }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bouncesZoom = true
        scrollView.decelerationRate = .fast

        let pdfURL = Bundle.main.url(forResource: "system-map-rail", withExtension: "pdf")
        if let url = pdfURL, let document = PDFDocument(url: url) {
            let size = CGSize(width: 2000, height: 1718)

            // Render the PDF to a high-res image (3x scale) in memory
            if let image = renderPDF(document: document, scale: 3.0) {
                let imageView = UIImageView(image: image)
                imageView.frame = CGRect(origin: .zero, size: size)
                imageView.accessibilityIdentifier = "dc_metro_silver.png"
                imageView.isUserInteractionEnabled = true

                let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
                imageView.addGestureRecognizer(tapGesture)

                scrollView.addSubview(imageView)
                scrollView.contentSize = size
                context.coordinator.imageView = imageView
            }
        }

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        context.coordinator.parent = self
        guard context.coordinator.imageView != nil else { return }

        let contentSize = CGSize(width: 2000, height: 1718)

        // Use viewSize provided by GeometryReader
        if viewSize.height > 0, context.coordinator.lastHeight != viewSize.height {
            context.coordinator.lastHeight = viewSize.height

            // Calculate minimum scale to fit height
            let heightScale = viewSize.height / contentSize.height

            uiView.minimumZoomScale = heightScale
            uiView.maximumZoomScale = 5.0

            // Set initial scale
            uiView.zoomScale = heightScale

            // Center horizontally if the content is wider than the screen
            let contentWidth = contentSize.width * heightScale
            if contentWidth > viewSize.width {
                let offsetX = (contentWidth - viewSize.width) / 2
                uiView.contentOffset = CGPoint(x: offsetX, y: 0)
            }

            // Call scrollViewDidZoom to ensure initial centering logic fires
            context.coordinator.scrollViewDidZoom(uiView)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ZoomableMapScrollView
        weak var imageView: UIImageView?
        var lastHeight: CGFloat = 0

        init(_ parent: ZoomableMapScrollView) {
            self.parent = parent
        }

        func viewForZooming(in _: UIScrollView) -> UIView? {
            return imageView
        }

        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            guard let imageView = imageView else { return }
            // Keeps the image perfectly centered if zoomed out smaller than the scroll view
            let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
            let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
            imageView.center = CGPoint(
                x: scrollView.contentSize.width * 0.5 + offsetX,
                y: scrollView.contentSize.height * 0.5 + offsetY
            )
        }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let imageView = imageView else { return }
            // Tap coordinates in the 2000x1718 coordinate space!
            let location = gesture.location(in: imageView)

            for region in MapRegions.all {
                if region.path.contains(location) {
                    let code = region.id.replacingOccurrences(of: "#", with: "")
                    let regionCodes = code.components(separatedBy: ",")
                    if let station = Station.allStations.first(where: { station in
                        let stationCodes = station.id.components(separatedBy: ",")
                        return !Set(regionCodes).isDisjoint(with: Set(stationCodes))
                    }) {
                        parent.selectedStation = station
                        return
                    }
                }
            }
        }
    }
}
