import SwiftUI

struct ContentView: View {
    @State private var activeTab = 0

    var body: some View {
        TabView(selection: $activeTab) {
            // TAB 1: FAVORITES
            FavoritesView(activeTab: $activeTab)
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
                .tag(0)

            // TAB 2: ALL STATIONS
            StationsListView()
                .tabItem {
                    Label("Stations", systemImage: "list.bullet")
                }
                .tag(1)

            // TAB 3: SYSTEM MAP
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
                .tag(2)
        }
    }
}

// MARK: - Extracted Component Views

// MARK: - 1. Favorites Tab View

struct FavoritesView: View {
    @Environment(FavoritesManager.self) var favoritesManager
    @Binding var activeTab: Int

    /// Correctly builds favorites preserving the user's order and aligning index operations
    private var favoritedStations: [Station] {
        favoritesManager.favoriteIDs.compactMap { id in
            Station.allStations.first { $0.id == id }
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if favoritedStations.isEmpty {
                    emptyFavoritesState
                } else {
                    List {
                        ForEach(favoritedStations) { station in
                            NavigationLink(value: station) {
                                StationRowView(station: station)
                            }
                        }
                        .onDelete { indexSet in
                            favoritesManager.delete(at: indexSet)
                        }
                        .onMove { source, destination in
                            favoritesManager.reorder(from: source, to: destination)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            EditButton()
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .navigationDestination(for: Station.self) { station in
                StationDetailView(station: station)
            }
        }
    }

    private var emptyFavoritesState: some View {
        VStack(spacing: 20) {
            Image(systemName: "star.bubble")
                .font(.system(size: 60))
                .foregroundColor(.orange)

            Text("No Favorites Yet")
                .font(.title3)
                .fontWeight(.bold)

            Text("Tap the star icon inside a station's live times, or tap a station on the system map to add it to your favorites.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button(action: {
                activeTab = 1 // Switch to all stations tab
            }) {
                Text("Browse All Stations")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
            }
        }
    }
}

// MARK: - 2. All Stations List Tab View

struct StationsListView: View {
    @State private var searchText = ""

    /// Responsive filtering utilizing pre-sorted static data source
    private var filteredStations: [Station] {
        if searchText.isEmpty {
            return Station.allStationsSorted
        } else {
            return Station.allStationsSorted.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if !searchText.isEmpty {
                    List(filteredStations) { station in
                        NavigationLink(value: station) {
                            StationRowView(station: station)
                        }
                    }
                    .listStyle(.plain)
                } else {
                    ScrollViewReader { proxy in
                        ZStack(alignment: .trailing) {
                            List {
                                ForEach(Station.groupedStations, id: \.letter) { section in
                                    Section(header: Text(section.letter).id(section.letter)) {
                                        ForEach(section.stations) { station in
                                            NavigationLink(value: station) {
                                                StationRowView(station: station)
                                            }
                                        }
                                    }
                                }
                            }
                            .listStyle(.plain)

                            AlphabetIndexSidebar(letters: Station.groupedStations.map { $0.letter }) { letter in
                                withAnimation {
                                    proxy.scrollTo(letter, anchor: .top)
                                }
                            }
                            .padding(.trailing, 8)
                        }
                    }
                }
            }
            .navigationTitle("DC Metro")
            .searchable(text: $searchText, prompt: "Search stations")
            .navigationDestination(for: Station.self) { station in
                StationDetailView(station: station)
            }
        }
    }
}

// MARK: - 3. System Map Tab View

struct MapView: View {
    @State private var selectedMapStation: Station?
    @State private var isMapLoading = true
    @State private var mapErrorMessage: String? = nil

    var body: some View {
        NavigationStack {
            WKWebViewWrapper(
                url: nil,
                isLocalHTML: true,
                onStationFragmentTapped: { code in
                    if let station = Station.allStations.first(where: { $0.id == code }) {
                        selectedMapStation = station
                    }
                },
                isLoading: $isMapLoading,
                errorMessage: $mapErrorMessage
            )
            .ignoresSafeArea()
            .overlay {
                if isMapLoading {
                    ProgressView("Loading System Map...")
                        .scaleEffect(1.2)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemBackground).opacity(0.8))
                        )
                }
            }
            .navigationTitle("System Map")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $selectedMapStation) { station in
                StationDetailView(station: station)
            }
        }
    }
}

// MARK: - 4. Station Row View

struct StationRowView: View {
    let station: Station

    var body: some View {
        HStack(spacing: 12) {
            Image(station.colorImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)

            Text(station.name)
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - 5. Alphabet Index Sidebar View

struct AlphabetIndexSidebar: View {
    let letters: [String]
    let onLetterSelected: (String) -> Void

    @State private var dragLetter: String? = nil

    var body: some View {
        VStack(spacing: 0) {
            ForEach(letters, id: \.self) { letter in
                Text(letter)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(dragLetter == letter ? .white : .blue)
                    .frame(width: 16, height: 16)
                    .background(
                        Circle()
                            .fill(dragLetter == letter ? Color.blue : Color.clear)
                    )
            }
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let y = value.location.y
                    let itemHeight: CGFloat = 16
                    let index = Int(y / itemHeight)
                    if index >= 0, index < letters.count {
                        let selectedLetter = letters[index]
                        if dragLetter != selectedLetter {
                            dragLetter = selectedLetter
                            onLetterSelected(selectedLetter)
                        }
                    }
                }
                .onEnded { _ in
                    dragLetter = nil
                }
        )
        .padding(.horizontal, 4)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color(.secondarySystemBackground).opacity(0.85))
                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
        )
        .sensoryFeedback(trigger: dragLetter) { oldValue, newValue in
            // Declarative, power-efficient iOS 17 selection haptics
            if newValue != nil && oldValue != newValue {
                return .selection
            }
            return nil
        }
    }
}
