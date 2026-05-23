import SwiftUI

struct NativeMapView: View {
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var selectedMapStation: Station? = nil
    @State private var hasSetInitialScale: Bool = false

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView([.horizontal, .vertical], showsIndicators: false) {
                    if let uiImage = UIImage(named: "dc_metro_silver.png") {
                        Image(uiImage: uiImage)
                            .resizable()
                            .accessibilityIdentifier("dc_metro_silver.png")
                            .scaledToFit()
                            .frame(width: uiImage.size.width * scale, height: uiImage.size.height * scale)
                            .gesture(
                                MagnifyGesture()
                                    .onChanged { value in
                                        let delta = value.magnification / lastScale
                                        lastScale = value.magnification
                                        scale = min(max(scale * delta, 0.2), 5.0)
                                    }
                                    .onEnded { _ in
                                        lastScale = 1.0
                                    }
                            )
                            .onTapGesture(coordinateSpace: .local) { location in
                                handleTap(at: location, currentSize: CGSize(width: uiImage.size.width * scale, height: uiImage.size.height * scale), originalSize: uiImage.size)
                            }
                    } else {
                        Text("Map image not found")
                            .foregroundColor(.red)
                    }
                }
                .defaultScrollAnchor(.center)
                .onAppear {
                    if !hasSetInitialScale && geometry.size.height > 0 {
                        if let uiImage = UIImage(named: "dc_metro_silver.png") {
                            scale = geometry.size.height / uiImage.size.height
                            hasSetInitialScale = true
                        }
                    }
                }
                .onChange(of: geometry.size) { _, newSize in
                    if !hasSetInitialScale && newSize.height > 0 {
                        if let uiImage = UIImage(named: "dc_metro_silver.png") {
                            scale = newSize.height / uiImage.size.height
                            hasSetInitialScale = true
                        }
                    }
                }
            }
            .navigationTitle("System Map")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $selectedMapStation) { station in
                StationDetailView(station: station)
            }
        }
    }

    private func handleTap(at location: CGPoint, currentSize: CGSize, originalSize: CGSize) {
        // Map the tap location from the current scaled size back to the original image coordinates
        let scaleX = originalSize.width / currentSize.width
        let scaleY = originalSize.height / currentSize.height

        let originalPoint = CGPoint(x: location.x * scaleX, y: location.y * scaleY)

        for region in MapRegions.all {
            if region.path.contains(originalPoint) {
                // Remove the '#' if present
                let code = region.id.replacingOccurrences(of: "#", with: "")
                let regionCodes = code.components(separatedBy: ",")
                if let station = Station.allStations.first(where: { station in
                    let stationCodes = station.id.components(separatedBy: ",")
                    return !Set(regionCodes).isDisjoint(with: Set(stationCodes))
                }) {
                    selectedMapStation = station
                    return
                }
            }
        }
    }
}
