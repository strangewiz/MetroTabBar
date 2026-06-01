import SwiftUI
import UIKit

struct NativeMapView: View {
    @State private var selectedMapStation: Station? = nil

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZoomableMapScrollView(
                    imageName: "dc_metro_silver.png",
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
    let imageName: String
    let viewSize: CGSize
    @Binding var selectedStation: Station?

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bouncesZoom = true
        scrollView.decelerationRate = .fast

        if let image = UIImage(named: imageName) {
            let imageView = UIImageView(image: image)
            imageView.accessibilityIdentifier = imageName
            imageView.isUserInteractionEnabled = true

            let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
            imageView.addGestureRecognizer(tapGesture)

            scrollView.addSubview(imageView)
            scrollView.contentSize = image.size
            context.coordinator.imageView = imageView
        }

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        context.coordinator.parent = self
        guard let imageView = context.coordinator.imageView, let image = imageView.image else { return }

        // Use viewSize provided by GeometryReader
        if viewSize.height > 0, context.coordinator.lastHeight != viewSize.height {
            context.coordinator.lastHeight = viewSize.height

            // Calculate minimum scale to fit height
            let heightScale = viewSize.height / image.size.height

            uiView.minimumZoomScale = heightScale
            uiView.maximumZoomScale = 5.0

            // Set initial scale
            uiView.zoomScale = heightScale

            // Center horizontally if the content is wider than the screen
            let contentWidth = image.size.width * heightScale
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
            // The beauty of UIKit: this is exactly in the original 2000x1718 coordinate space!
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
