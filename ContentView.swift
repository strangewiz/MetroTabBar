import SwiftUI

struct ContentView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var searchText = ""
    @State private var selectedStation: Station? = nil
    @State private var isMapLoading = true
    @State private var activeTab = 0
    
    // Group stations alphabetically
    private var groupedStations: [(letter: String, stations: [Station])] {
        let sortedAll = Station.allStations.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
        let grouped = Dictionary(grouping: sortedAll) { station -> String in
            guard let first = station.name.first else { return "#" }
            return String(first).uppercased()
        }
        return grouped.map { (letter: $0.key, stations: $0.value) }
            .sorted { $0.letter < $1.letter }
    }
    
    // Filter stations based on search text
    private var filteredStations: [Station] {
        if searchText.isEmpty {
            return Station.allStations.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
        } else {
            return Station.allStations.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
                .sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
        }
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $activeTab) {
                // TAB 1: FAVORITES
                favoritesView
                    .tabItem {
                        Label("Favorites", systemImage: "star.fill")
                    }
                    .tag(0)
                
                // TAB 2: ALL STATIONS
                stationsListView
                    .tabItem {
                        Label("Stations", systemImage: "list.bullet")
                    }
                    .tag(1)
                
                // TAB 3: SYSTEM MAP
                mapView
                    .tabItem {
                        Label("Map", systemImage: "map.fill")
                    }
                    .tag(2)
            }
            .navigationDestination(item: $selectedStation) { station in
                StationDetailView(station: station)
            }
        }
    }
    
    // MARK: - Favorites View Block
    private var favoritesView: some View {
        VStack {
            let favoritedStations = Station.allStations.filter { favoritesManager.favoriteIDs.contains($0.id) }
            
            if favoritedStations.isEmpty {
                emptyFavoritesState
            } else {
                List {
                    ForEach(favoritedStations) { station in
                        Button(action: {
                            selectedStation = station
                        }) {
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
                .listStyle(InsetGroupedListStyle())
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if !favoritedStations.isEmpty && activeTab == 0 {
                            EditButton()
                        }
                    }
                }
            }
        }
        .navigationTitle("Favorites")
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
                activeTab = 1 // Switch to all stations
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
    
    // MARK: - All Stations List View Block
    private var stationsListView: some View {
        VStack {
            if !searchText.isEmpty {
                List(filteredStations) { station in
                    Button(action: {
                        selectedStation = station
                    }) {
                        StationRowView(station: station)
                    }
                }
                .listStyle(PlainListStyle())
            } else {
                List {
                    ForEach(groupedStations, id: \.letter) { section in
                        Section(header: Text(section.letter)) {
                            ForEach(section.stations) { station in
                                Button(action: {
                                    selectedStation = station
                                }) {
                                    StationRowView(station: station)
                                }
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("DC Metro")
        .searchable(text: $searchText, prompt: "Search stations")
    }
    
    // MARK: - Interactive HTML Map Block
    private var mapView: some View {
        ZStack {
            WKWebViewWrapper(
                url: nil,
                isLocalHTML: true,
                onStationFragmentTapped: { code in
                    // Look up station by site code
                    if let station = Station.allStations.first(where: { $0.id == code }) {
                        selectedStation = station
                    }
                },
                isLoading: $isMapLoading
            )
            .edgesIgnoringSafeArea(.all)
            
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
    }
}

// MARK: - Station Row Representation View
struct StationRowView: View {
    let station: Station
    
    var body: some View {
        HStack(spacing: 12) {
            if let uiImage = UIImage(named: "metrolinescolors/\(station.colorImageName).png") ?? UIImage(named: "\(station.colorImageName).png") {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 32, height: 32)
            }
            
            Text(station.name)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}
