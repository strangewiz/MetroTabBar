import Foundation

struct Station: Identifiable, Hashable {
    let id: String // site code (e.g. "G03")
    let name: String
    let colorImageName: String // color image tag (e.g. "b", "gyr")

    var webName: String {
        // Hyphenate name and lowercase it to match WMATA URL structure
        name.lowercased()
            .replacingOccurrences(of: "/", with: "-")
            .replacingOccurrences(of: " ", with: "-")
            .replacingOccurrences(of: "--", with: "-")
    }

    var webURL: URL? {
        URL(string: "https://www.wmata.com/ridertools/station/\(webName)")
    }

    /// Explicit Hashable & Equatable based only on the unique id
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Station, rhs: Station) -> Bool {
        lhs.id == rhs.id
    }

    static let allStations: [Station] = [
        Station(id: "G03", name: "Addison Rd", colorImageName: "b"),
        Station(id: "F06", name: "Anacostia", colorImageName: "g"),
        Station(id: "F02", name: "Archives", colorImageName: "gy"),
        Station(id: "C06", name: "Arlington Cemetery", colorImageName: "b"),
        Station(id: "N12", name: "Ashburn", colorImageName: "s"),
        Station(id: "K04", name: "Ballston-MU", colorImageName: "o"),
        Station(id: "G01", name: "Benning Rd", colorImageName: "b"),
        Station(id: "A09", name: "Bethesda", colorImageName: "r"),
        Station(id: "C12", name: "Braddock Rd", colorImageName: "by"),
        Station(id: "F11", name: "Branch Av", colorImageName: "g"),
        Station(id: "B05", name: "Brookland-CUA", colorImageName: "r"),
        Station(id: "G02", name: "Capitol Heights", colorImageName: "b"),
        Station(id: "D05", name: "Capitol South", colorImageName: "bo"),
        Station(id: "D11", name: "Cheverly", colorImageName: "o"),
        Station(id: "K02", name: "Clarendon", colorImageName: "o"),
        Station(id: "A05", name: "Cleveland Park", colorImageName: "r"),
        Station(id: "E09", name: "College Park-U of MD", colorImageName: "g"),
        Station(id: "E04", name: "Columbia Heights", colorImageName: "gy"),
        Station(id: "F07", name: "Congress Heights", colorImageName: "g"),
        Station(id: "K01", name: "Court House", colorImageName: "o"),
        Station(id: "C09", name: "Crystal City", colorImageName: "by"),
        Station(id: "D10", name: "Deanwood", colorImageName: "o"),
        Station(id: "K07", name: "Dunn Loring", colorImageName: "o"),
        Station(id: "A03", name: "Dupont Circle", colorImageName: "r"),
        Station(id: "K05", name: "East Falls Church", colorImageName: "o"),
        Station(id: "D06", name: "Eastern Market", colorImageName: "bo"),
        Station(id: "C14", name: "Eisenhower Av", colorImageName: "y"),
        Station(id: "A02", name: "Farragut North", colorImageName: "r"),
        Station(id: "C03", name: "Farragut West", colorImageName: "bo"),
        Station(id: "D04", name: "Federal Center SW", colorImageName: "bo"),
        Station(id: "D01", name: "Federal Triangle", colorImageName: "bo"),
        Station(id: "C04", name: "Foggy Bottom-GWU", colorImageName: "bo"),
        Station(id: "B09", name: "Forest Glen", colorImageName: "r"),
        Station(id: "E06,B06", name: "Fort Totten", colorImageName: "gyr"),
        Station(id: "J03", name: "Franconia-Springfield", colorImageName: "b"),
        Station(id: "A08", name: "Friendship Heights", colorImageName: "r"),
        Station(id: "B01,F01", name: "Gallery Place", colorImageName: "gyr"),
        Station(id: "E05", name: "Georgia Av Petworth", colorImageName: "gy"),
        Station(id: "B11", name: "Glenmont", colorImageName: "r"),
        Station(id: "E10", name: "Greenbelt", colorImageName: "g"),
        Station(id: "N03", name: "Greensboro", colorImageName: "s"),
        Station(id: "A11", name: "Grosvenor-Strathmore", colorImageName: "r"),
        Station(id: "N08", name: "Herndon", colorImageName: "s"),
        Station(id: "C15", name: "Huntington", colorImageName: "y"),
        Station(id: "N09", name: "Innovation Center", colorImageName: "s"),
        Station(id: "B02", name: "Judiciary Sq", colorImageName: "r"),
        Station(id: "C13", name: "King St-Old Town", colorImageName: "by"),
        Station(id: "F03,D03", name: "L'Enfant Plaza", colorImageName: "bogy"),
        Station(id: "D12", name: "Landover", colorImageName: "o"),
        Station(id: "G05", name: "Downtown Largo", colorImageName: "b"),
        Station(id: "N11", name: "Loudoun Gateway", colorImageName: "s"),
        Station(id: "N01", name: "McLean", colorImageName: "s"),
        Station(id: "C02", name: "McPherson Sq", colorImageName: "bo"),
        Station(id: "A10", name: "Medical Center", colorImageName: "r"),
        Station(id: "C01,A01", name: "Metro Center", colorImageName: "bor"),
        Station(id: "D09", name: "Minnesota Av", colorImageName: "o"),
        Station(id: "G04", name: "Morgan Blvd", colorImageName: "b"),
        Station(id: "E01", name: "Mt Vernon Sq", colorImageName: "gy"),
        Station(id: "F05", name: "Navy Yard-Ballpark", colorImageName: "g"),
        Station(id: "F09", name: "Naylor Rd", colorImageName: "g"),
        Station(id: "D13", name: "New Carrollton", colorImageName: "o"),
        Station(id: "B35", name: "NoMa-Gallaudet U", colorImageName: "r"),
        Station(id: "C07", name: "Pentagon", colorImageName: "by"),
        Station(id: "C08", name: "Pentagon City", colorImageName: "by"),
        Station(id: "D07", name: "Potomac Av", colorImageName: "bo"),
        Station(id: "E08", name: "Hyattsville Crossing", colorImageName: "g"),
        Station(id: "N07", name: "Reston Town Center", colorImageName: "s"),
        Station(id: "B04", name: "Rhode Island Av", colorImageName: "r"),
        Station(id: "A14", name: "Rockville", colorImageName: "r"),
        Station(id: "C10", name: "Ronald Reagan Washington National Airport", colorImageName: "by"),
        Station(id: "C05", name: "Rosslyn", colorImageName: "bo"),
        Station(id: "A15", name: "Shady Grove", colorImageName: "r"),
        Station(id: "E02", name: "Shaw-Howard U", colorImageName: "gy"),
        Station(id: "B08", name: "Silver Spring", colorImageName: "r"),
        Station(id: "D02", name: "Smithsonian", colorImageName: "bo"),
        Station(id: "F08", name: "Southern Av", colorImageName: "g"),
        Station(id: "N04", name: "Spring Hill", colorImageName: "s"),
        Station(id: "D08", name: "Stadium-Armory", colorImageName: "bo"),
        Station(id: "F10", name: "Suitland", colorImageName: "g"),
        Station(id: "B07", name: "Takoma", colorImageName: "r"),
        Station(id: "A07", name: "Tenleytown-AU", colorImageName: "r"),
        Station(id: "A13", name: "Twinbrook", colorImageName: "r"),
        Station(id: "N02", name: "Tysons", colorImageName: "s"),
        Station(id: "E03", name: "U St", colorImageName: "gy"),
        Station(id: "B03", name: "Union Station", colorImageName: "r"),
        Station(id: "J02", name: "Van Dorn St", colorImageName: "b"),
        Station(id: "A06", name: "Van Ness-UDC", colorImageName: "r"),
        Station(id: "K08", name: "Vienna", colorImageName: "o"),
        Station(id: "K03", name: "Virginia Sq-GMU", colorImageName: "o"),
        Station(id: "N10", name: "Washington Dulles International Airport", colorImageName: "s"),
        Station(id: "F04", name: "Waterfront", colorImageName: "g"),
        Station(id: "K06", name: "West Falls Church", colorImageName: "o"),
        Station(id: "E07", name: "West Hyattsville", colorImageName: "g"),
        Station(id: "B10", name: "Wheaton", colorImageName: "r"),
        Station(id: "A12", name: "North Bethesda", colorImageName: "r"),
        Station(id: "N06", name: "Wiehle-Reston East", colorImageName: "s"),
        Station(id: "A04", name: "Woodley Park", colorImageName: "r"),
    ]

    /// Precomputed sorted station list to avoid expensive sorting during UI updates
    static let allStationsSorted: [Station] = allStations.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }

    /// Precomputed alphabetically grouped sections for ultra-high-efficiency rendering
    static let groupedStations: [(letter: String, stations: [Station])] = {
        let grouped = Dictionary(grouping: allStationsSorted) { station -> String in
            guard let first = station.name.first else { return "#" }
            return String(first).uppercased()
        }
        return grouped.map { (letter: $0.key, stations: $0.value) }
            .sorted { $0.letter < $1.letter }
    }()
}
