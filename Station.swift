import Foundation

struct Station: Identifiable, Codable, Hashable {
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
    
    static let allStations: [Station] = [
        Station(id: "G03", name: "Addison Road-Seat Pleasant", colorImageName: "b"),
        Station(id: "F06", name: "Anacostia", colorImageName: "g"),
        Station(id: "F02", name: "Archives-Navy Memorial-Penn Quarter", colorImageName: "gy"),
        Station(id: "C06", name: "Arlington Cemetery", colorImageName: "b"),
        Station(id: "N12", name: "Ashburn", colorImageName: "s"),
        Station(id: "K04", name: "Ballston-MU", colorImageName: "o"),
        Station(id: "G01", name: "Benning Road", colorImageName: "b"),
        Station(id: "A09", name: "Bethesda", colorImageName: "r"),
        Station(id: "C12", name: "Braddock Road", colorImageName: "by"),
        Station(id: "F11", name: "Branch Ave", colorImageName: "g"),
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
        Station(id: "K07", name: "Dunn Loring-Merrifield", colorImageName: "o"),
        Station(id: "A03", name: "Dupont Circle", colorImageName: "r"),
        Station(id: "K05", name: "East Falls Church", colorImageName: "o"),
        Station(id: "D06", name: "Eastern Market", colorImageName: "bo"),
        Station(id: "C14", name: "Eisenhower Avenue", colorImageName: "y"),
        Station(id: "A02", name: "Farragut North", colorImageName: "r"),
        Station(id: "C03", name: "Farragut West", colorImageName: "bo"),
        Station(id: "D04", name: "Federal Center SW", colorImageName: "bo"),
        Station(id: "D01", name: "Federal Triangle", colorImageName: "bo"),
        Station(id: "C04", name: "Foggy Bottom-GWU", colorImageName: "bo"),
        Station(id: "B09", name: "Forest Glen", colorImageName: "r"),
        Station(id: "E06,B06", name: "Fort Totten", colorImageName: "gyr"),
        Station(id: "J03", name: "Franconia-Springfield", colorImageName: "b"),
        Station(id: "A08", name: "Friendship Heights", colorImageName: "r"),
        Station(id: "B01,F01", name: "Gallery Pl-Chinatown", colorImageName: "gyr"),
        Station(id: "E05", name: "Georgia Ave-Petworth", colorImageName: "gy"),
        Station(id: "B11", name: "Glenmont", colorImageName: "r"),
        Station(id: "E10", name: "Greenbelt", colorImageName: "g"),
        Station(id: "N03", name: "Greensboro", colorImageName: "s"),
        Station(id: "A11", name: "Grosvenor-Strathmore", colorImageName: "r"),
        Station(id: "N08", name: "Herndon", colorImageName: "s"),
        Station(id: "C15", name: "Huntington", colorImageName: "y"),
        Station(id: "N09", name: "Innovation Center", colorImageName: "s"),
        Station(id: "B02", name: "Judiciary Square", colorImageName: "r"),
        Station(id: "C13", name: "King St-Old Town", colorImageName: "by"),
        Station(id: "F03,D03", name: "L'Enfant Plaza", colorImageName: "bogy"),
        Station(id: "D12", name: "Landover", colorImageName: "o"),
        Station(id: "G05", name: "Largo Town Center", colorImageName: "b"),
        Station(id: "N11", name: "Loudon Gateway", colorImageName: "s"),
        Station(id: "N01", name: "McLean", colorImageName: "s"),
        Station(id: "C02", name: "McPherson Square", colorImageName: "bo"),
        Station(id: "A10", name: "Medical Center", colorImageName: "r"),
        Station(id: "C01,A01", name: "Metro Center", colorImageName: "bor"),
        Station(id: "D09", name: "Minnesota Ave", colorImageName: "o"),
        Station(id: "G04", name: "Morgan Boulevard", colorImageName: "b"),
        Station(id: "E01", name: "Mt Vernon Sq 7th St-Convention Center", colorImageName: "gy"),
        Station(id: "F05", name: "Navy Yard-Ballpark", colorImageName: "g"),
        Station(id: "F09", name: "Naylor Road", colorImageName: "g"),
        Station(id: "D13", name: "New Carrollton", colorImageName: "o"),
        Station(id: "B35", name: "NoMa-Gallaudet U", colorImageName: "r"),
        Station(id: "C07", name: "Pentagon", colorImageName: "by"),
        Station(id: "C08", name: "Pentagon City", colorImageName: "by"),
        Station(id: "D07", name: "Potomac Ave", colorImageName: "bo"),
        Station(id: "E08", name: "Prince George's Plaza", colorImageName: "g"),
        Station(id: "N07", name: "Reston Town Center", colorImageName: "s"),
        Station(id: "B04", name: "Rhode Island Ave-Brentwood", colorImageName: "r"),
        Station(id: "A14", name: "Rockville", colorImageName: "r"),
        Station(id: "C10", name: "Ronald Reagan Washington National Airport", colorImageName: "by"),
        Station(id: "C05", name: "Rosslyn", colorImageName: "bo"),
        Station(id: "A15", name: "Shady Grove", colorImageName: "r"),
        Station(id: "E02", name: "Shaw-Howard U", colorImageName: "gy"),
        Station(id: "B08", name: "Silver Spring", colorImageName: "r"),
        Station(id: "D02", name: "Smithsonian", colorImageName: "bo"),
        Station(id: "F08", name: "Southern Avenue", colorImageName: "g"),
        Station(id: "N04", name: "Spring Hill", colorImageName: "s"),
        Station(id: "D08", name: "Stadium-Armory", colorImageName: "bo"),
        Station(id: "F10", name: "Suitland", colorImageName: "g"),
        Station(id: "B07", name: "Takoma", colorImageName: "r"),
        Station(id: "A07", name: "Tenleytown-AU", colorImageName: "r"),
        Station(id: "A13", name: "Twinbrook", colorImageName: "r"),
        Station(id: "N02", name: "Tysons Corner", colorImageName: "s"),
        Station(id: "E03", name: "U Street/African-Amer Civil War Memorial/Cardozo", colorImageName: "gy"),
        Station(id: "B03", name: "Union Station", colorImageName: "r"),
        Station(id: "J02", name: "Van Dorn Street", colorImageName: "b"),
        Station(id: "A06", name: "Van Ness-UDC", colorImageName: "r"),
        Station(id: "K08", name: "Vienna/Fairfax-GMU", colorImageName: "o"),
        Station(id: "K03", name: "Virginia Square-GMU", colorImageName: "o"),
        // Note: Corrected typo 'Washingotn' in original app plist to 'Washington'
        Station(id: "N10", name: "Washington Dulles International Airport", colorImageName: "s"),
        Station(id: "F04", name: "Waterfront", colorImageName: "g"),
        Station(id: "K06", name: "West Falls Church-VT/UVA", colorImageName: "o"),
        Station(id: "E07", name: "West Hyattsville", colorImageName: "g"),
        Station(id: "B10", name: "Wheaton", colorImageName: "r"),
        Station(id: "A12", name: "White Flint", colorImageName: "r"),
        Station(id: "N06", name: "Wiehle-Reston East", colorImageName: "s"),
        Station(id: "A04", name: "Woodley Park-Zoo/Adams Morgan", colorImageName: "r")
    ]
}
