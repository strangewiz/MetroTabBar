import CoreLocation
import Foundation

struct Station: Identifiable, Hashable {
    let id: String // site code (e.g. "G03")
    let name: String
    let colorImageName: String // color image tag (e.g. "b", "gyr")
    let lat: Double
    let lon: Double

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

    func distance(to location: CLLocation?) -> CLLocationDistance? {
        guard let location = location else { return nil }
        let stationLoc = CLLocation(latitude: lat, longitude: lon)
        return stationLoc.distance(from: location)
    }

    /// Explicit Hashable & Equatable based only on the unique id
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Station, rhs: Station) -> Bool {
        lhs.id == rhs.id
    }

    static let allStations: [Station] = [
        Station(id: "G03", name: "Addison Rd", colorImageName: "sb", lat: 38.886713, lon: -76.893592),
        Station(id: "F06", name: "Anacostia", colorImageName: "g", lat: 38.862073, lon: -76.995398),
        Station(id: "F02", name: "Archives", colorImageName: "gy", lat: 38.893675, lon: -77.021914),
        Station(id: "C06", name: "Arlington Cemetery", colorImageName: "b", lat: 38.884574, lon: -77.063108),
        Station(id: "N12", name: "Ashburn", colorImageName: "s", lat: 39.006612, lon: -77.489145),
        Station(id: "K04", name: "Ballston-MU", colorImageName: "os", lat: 38.882071, lon: -77.111845),
        Station(id: "G01", name: "Benning Rd", colorImageName: "sb", lat: 38.890488, lon: -76.938291),
        Station(id: "A09", name: "Bethesda", colorImageName: "r", lat: 38.984282, lon: -77.094431),
        Station(id: "C12", name: "Braddock Rd", colorImageName: "by", lat: 38.814577, lon: -77.053733),
        Station(id: "F11", name: "Branch Av", colorImageName: "g", lat: 38.826995, lon: -76.912134),
        Station(id: "B05", name: "Brookland-CUA", colorImageName: "r", lat: 38.933234, lon: -76.994544),
        Station(id: "G02", name: "Capitol Heights", colorImageName: "sb", lat: 38.889757, lon: -76.913382),
        Station(id: "D05", name: "Capitol South", colorImageName: "bo", lat: 38.885062, lon: -77.005934),
        Station(id: "D11", name: "Cheverly", colorImageName: "o", lat: 38.91652, lon: -76.915427),
        Station(id: "K02", name: "Clarendon", colorImageName: "os", lat: 38.886373, lon: -77.094953),
        Station(id: "A05", name: "Cleveland Park", colorImageName: "r", lat: 38.934703, lon: -77.058226),
        Station(id: "E09", name: "College Park-U of MD", colorImageName: "g", lat: 38.978523, lon: -76.928432),
        Station(id: "E04", name: "Columbia Heights", colorImageName: "gy", lat: 38.927826, lon: -77.032536),
        Station(id: "F07", name: "Congress Heights", colorImageName: "g", lat: 38.845334, lon: -76.98817),
        Station(id: "K01", name: "Court House", colorImageName: "os", lat: 38.89063, lon: -77.084803),
        Station(id: "C09", name: "Crystal City", colorImageName: "by", lat: 38.85779, lon: -77.050589),
        Station(id: "D10", name: "Deanwood", colorImageName: "o", lat: 38.907734, lon: -76.936177),
        Station(id: "K07", name: "Dunn Loring", colorImageName: "o", lat: 38.883015, lon: -77.228939),
        Station(id: "A03", name: "Dupont Circle", colorImageName: "r", lat: 38.909499, lon: -77.04362),
        Station(id: "K05", name: "East Falls Church", colorImageName: "os", lat: 38.885841, lon: -77.157177),
        Station(id: "D06", name: "Eastern Market", colorImageName: "osb", lat: 38.884124, lon: -76.995334),
        Station(id: "C14", name: "Eisenhower Av", colorImageName: "y", lat: 38.800313, lon: -77.071173),
        Station(id: "A02", name: "Farragut North", colorImageName: "r", lat: 38.903192, lon: -77.039766),
        Station(id: "C03", name: "Farragut West", colorImageName: "osb", lat: 38.901311, lon: -77.03981),
        Station(id: "D04", name: "Federal Center SW", colorImageName: "osb", lat: 38.884958, lon: -77.01586),
        Station(id: "D01", name: "Federal Triangle", colorImageName: "osb", lat: 38.893757, lon: -77.028218),
        Station(id: "C04", name: "Foggy Bottom-GWU", colorImageName: "osb", lat: 38.900599, lon: -77.050273),
        Station(id: "B09", name: "Forest Glen", colorImageName: "r", lat: 39.015413, lon: -77.042953),
        Station(id: "E06,B06", name: "Fort Totten", colorImageName: "gyr", lat: 38.951777, lon: -77.002174),
        Station(id: "J03", name: "Franconia-Springfield", colorImageName: "b", lat: 38.766129, lon: -77.168797),
        Station(id: "A08", name: "Friendship Heights", colorImageName: "r", lat: 38.960744, lon: -77.085969),
        Station(id: "B01,F01", name: "Gallery Place", colorImageName: "gyr", lat: 38.89834, lon: -77.021851),
        Station(id: "E05", name: "Georgia Av Petworth", colorImageName: "gy", lat: 38.936077, lon: -77.024728),
        Station(id: "B11", name: "Glenmont", colorImageName: "r", lat: 39.061713, lon: -77.05341),
        Station(id: "E10", name: "Greenbelt", colorImageName: "g", lat: 39.011036, lon: -76.911362),
        Station(id: "N03", name: "Greensboro", colorImageName: "s", lat: 38.919749, lon: -77.235192),
        Station(id: "A11", name: "Grosvenor-Strathmore", colorImageName: "r", lat: 39.029158, lon: -77.10415),
        Station(id: "N08", name: "Herndon", colorImageName: "s", lat: 38.952821, lon: -77.385178),
        Station(id: "C15", name: "Huntington", colorImageName: "y", lat: 38.793841, lon: -77.075301),
        Station(id: "N09", name: "Innovation Center", colorImageName: "s", lat: 38.960758, lon: -77.415295),
        Station(id: "B02", name: "Judiciary Sq", colorImageName: "r", lat: 38.896084, lon: -77.016643),
        Station(id: "C13", name: "King St-Old Town", colorImageName: "by", lat: 38.806474, lon: -77.061115),
        Station(id: "F03,D03", name: "L'Enfant Plaza", colorImageName: "bogys", lat: 38.884775, lon: -77.021964),
        Station(id: "D12", name: "Landover", colorImageName: "o", lat: 38.934411, lon: -76.890988),
        Station(id: "G05", name: "Downtown Largo", colorImageName: "sb", lat: 38.9008, lon: -76.8449),
        Station(id: "N11", name: "Loudoun Gateway", colorImageName: "s", lat: 38.99204, lon: -77.460685),
        Station(id: "N01", name: "McLean", colorImageName: "s", lat: 38.924478, lon: -77.210167),
        Station(id: "C02", name: "McPherson Sq", colorImageName: "osb", lat: 38.901316, lon: -77.033652),
        Station(id: "A10", name: "Medical Center", colorImageName: "r", lat: 38.999947, lon: -77.097253),
        Station(id: "C01,A01", name: "Metro Center", colorImageName: "bors", lat: 38.898303, lon: -77.028099),
        Station(id: "D09", name: "Minnesota Av", colorImageName: "o", lat: 38.898284, lon: -76.948042),
        Station(id: "G04", name: "Morgan Blvd", colorImageName: "sb", lat: 38.8913, lon: -76.8682),
        Station(id: "E01", name: "Mt Vernon Sq", colorImageName: "gy", lat: 38.905604, lon: -77.022256),
        Station(id: "F05", name: "Navy Yard-Ballpark", colorImageName: "g", lat: 38.876588, lon: -77.005086),
        Station(id: "F09", name: "Naylor Rd", colorImageName: "g", lat: 38.851187, lon: -76.956565),
        Station(id: "D13", name: "New Carrollton", colorImageName: "o", lat: 38.947674, lon: -76.872144),
        Station(id: "B35", name: "NoMa-Gallaudet U", colorImageName: "r", lat: 38.907407, lon: -77.002961),
        Station(id: "C07", name: "Pentagon", colorImageName: "by", lat: 38.869349, lon: -77.054013),
        Station(id: "C08", name: "Pentagon City", colorImageName: "by", lat: 38.863045, lon: -77.059507),
        Station(id: "D07", name: "Potomac Av", colorImageName: "osb", lat: 38.880841, lon: -76.985721),
        Station(id: "E08", name: "Hyattsville Crossing", colorImageName: "g", lat: 38.965276, lon: -76.956182),
        Station(id: "N07", name: "Reston Town Center", colorImageName: "s", lat: 38.952768, lon: -77.360185),
        Station(id: "B04", name: "Rhode Island Av", colorImageName: "r", lat: 38.920741, lon: -76.995984),
        Station(id: "A14", name: "Rockville", colorImageName: "r", lat: 39.084215, lon: -77.146424),
        Station(id: "C10", name: "Ronald Reagan Washington National Airport", colorImageName: "by", lat: 38.852985, lon: -77.043805),
        Station(id: "C05", name: "Rosslyn", colorImageName: "osb", lat: 38.896595, lon: -77.07146),
        Station(id: "A15", name: "Shady Grove", colorImageName: "r", lat: 39.119819, lon: -77.164921),
        Station(id: "E02", name: "Shaw-Howard U", colorImageName: "gy", lat: 38.912919, lon: -77.022194),
        Station(id: "B08", name: "Silver Spring", colorImageName: "r", lat: 38.993841, lon: -77.031321),
        Station(id: "D02", name: "Smithsonian", colorImageName: "osb", lat: 38.888022, lon: -77.028232),
        Station(id: "F08", name: "Southern Av", colorImageName: "g", lat: 38.840974, lon: -76.97536),
        Station(id: "N04", name: "Spring Hill", colorImageName: "s", lat: 38.929273, lon: -77.241988),
        Station(id: "D08", name: "Stadium-Armory", colorImageName: "osb", lat: 38.88594, lon: -76.977485),
        Station(id: "F10", name: "Suitland", colorImageName: "g", lat: 38.843891, lon: -76.932022),
        Station(id: "B07", name: "Takoma", colorImageName: "r", lat: 38.975532, lon: -77.017834),
        Station(id: "A07", name: "Tenleytown-AU", colorImageName: "r", lat: 38.947808, lon: -77.079615),
        Station(id: "A13", name: "Twinbrook", colorImageName: "r", lat: 39.062359, lon: -77.121113),
        Station(id: "N02", name: "Tysons", colorImageName: "s", lat: 38.920056, lon: -77.223314),
        Station(id: "E03", name: "U St", colorImageName: "gy", lat: 38.916489, lon: -77.028938),
        Station(id: "B03", name: "Union Station", colorImageName: "r", lat: 38.897723, lon: -77.006745),
        Station(id: "J02", name: "Van Dorn St", colorImageName: "b", lat: 38.799193, lon: -77.129407),
        Station(id: "A06", name: "Van Ness-UDC", colorImageName: "r", lat: 38.94362, lon: -77.063511),
        Station(id: "K08", name: "Vienna", colorImageName: "o", lat: 38.877693, lon: -77.271562),
        Station(id: "K03", name: "Virginia Sq-GMU", colorImageName: "os", lat: 38.88331, lon: -77.104267),
        Station(id: "N10", name: "Washington Dulles International Airport", colorImageName: "s", lat: 38.955784, lon: -77.448148),
        Station(id: "F04", name: "Waterfront", colorImageName: "g", lat: 38.876221, lon: -77.017491),
        Station(id: "K06", name: "West Falls Church", colorImageName: "o", lat: 38.90067, lon: -77.189394),
        Station(id: "E07", name: "West Hyattsville", colorImageName: "g", lat: 38.954931, lon: -76.969881),
        Station(id: "B10", name: "Wheaton", colorImageName: "r", lat: 39.038558, lon: -77.051098),
        Station(id: "A12", name: "North Bethesda", colorImageName: "r", lat: 39.048043, lon: -77.113131),
        Station(id: "N06", name: "Wiehle-Reston East", colorImageName: "s", lat: 38.947753, lon: -77.340179),
        Station(id: "A04", name: "Woodley Park", colorImageName: "r", lat: 38.924999, lon: -77.052648),
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
