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

class PDFMapView: UIView {
    private let page: PDFPage

    override class var layerClass: AnyClass {
        return CATiledLayer.self
    }

    init(frame: CGRect, document: PDFDocument) {
        guard let firstPage = document.page(at: 0) else {
            fatalError("Could not load PDF page")
        }
        page = firstPage
        super.init(frame: frame)
        backgroundColor = .white

        // Configure tiled layer for crisp details on high zooms
        if let tiledLayer = layer as? CATiledLayer {
            tiledLayer.levelsOfDetail = 4
            tiledLayer.levelsOfDetailBias = 4
            tiledLayer.tileSize = CGSize(width: 512, height: 512)
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.saveGState()

        // Flip coordinates for Y-up PDF rendering
        context.translateBy(x: 0, y: bounds.height)
        context.scaleBy(x: 1.0, y: -1.0)

        // Scale to match the MapRegions coordinate system (2000 x 1718)
        // PDF points: 1080 x 1312
        context.scaleBy(x: 1.92, y: 1.92)

        // Translate to the bottom-left of our crop box in Y-up PDF space
        // tx = 16.6667 pt
        // ty = 1312.0 (PDF height) - 283.3333 (top crop) - 894.7917 (cropped height) = 133.875 pt
        context.translateBy(x: -16.6667, y: -133.875)

        if let pageRef = page.pageRef {
            context.drawPDFPage(pageRef)
        }

        context.restoreGState()
    }
}

struct ZoomableMapScrollView: UIViewRepresentable {
    let viewSize: CGSize
    @Binding var selectedStation: Station?

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
            let mapView = PDFMapView(frame: CGRect(origin: .zero, size: size), document: document)
            mapView.accessibilityIdentifier = "dc_metro_silver.png"
            mapView.accessibilityTraits = .image
            mapView.isUserInteractionEnabled = true

            let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
            mapView.addGestureRecognizer(tapGesture)

            scrollView.addSubview(mapView)
            scrollView.contentSize = size
            context.coordinator.mapView = mapView
        }

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        context.coordinator.parent = self
        guard context.coordinator.mapView != nil else { return }

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
        weak var mapView: PDFMapView?
        var lastHeight: CGFloat = 0

        init(_ parent: ZoomableMapScrollView) {
            self.parent = parent
        }

        func viewForZooming(in _: UIScrollView) -> UIView? {
            return mapView
        }

        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            guard let mapView = mapView else { return }
            // Keeps the image perfectly centered if zoomed out smaller than the scroll view
            let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
            let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
            mapView.center = CGPoint(
                x: scrollView.contentSize.width * 0.5 + offsetX,
                y: scrollView.contentSize.height * 0.5 + offsetY
            )
        }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let mapView = mapView else { return }
            // Tap coordinates in the 2000x1718 coordinate space!
            let location = gesture.location(in: mapView)

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
