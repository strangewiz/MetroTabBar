import Foundation

struct WMATATrainPrediction: Codable, Identifiable, Hashable {
    var id: String {
        "\(line)-\(destinationCode ?? "UNK")-\(min)-\(group)"
    }

    let car: String?
    let destination: String
    let destinationCode: String?
    let destinationName: String
    let group: String
    let line: String
    let locationCode: String
    let locationName: String
    let min: String

    enum CodingKeys: String, CodingKey {
        case car = "Car"
        case destination = "Destination"
        case destinationCode = "DestinationCode"
        case destinationName = "DestinationName"
        case group = "Group"
        case line = "Line"
        case locationCode = "LocationCode"
        case locationName = "LocationName"
        case min = "Min"
    }
}

struct WMATAPredictionResponse: Codable {
    let trains: [WMATATrainPrediction]

    enum CodingKeys: String, CodingKey {
        case trains = "Trains"
    }
}

class WMATAClient {
    static let shared = WMATAClient()

    func fetchPredictions(for stationCode: String) async throws -> [WMATATrainPrediction] {
        let cleanedCode = stationCode.replacingOccurrences(of: " ", with: "")
        guard !cleanedCode.isEmpty else { return [] }

        let urlString = "https://api.wmata.com/StationPrediction.svc/json/GetPrediction/\(cleanedCode)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.setValue(Secrets.wmataApiKey, forHTTPHeaderField: "api_key")
        request.timeoutInterval = 10.0

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(WMATAPredictionResponse.self, from: data)
        return decoded.trains
    }
}

struct TrackingOption: Identifiable, Equatable {
    let id = UUID()
    let directionGroup: String
    let label: String
    let lines: [String]
}

extension WMATAClient {
    static func resolveTrackingOptions(
        for station: Station,
        predictionsBySubcode: [String: [WMATATrainPrediction]]
    ) -> [TrackingOption] {
        let subCodes = station.id.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
        var options: [TrackingOption] = []

        for subCode in subCodes {
            guard !subCode.isEmpty else { continue }
            let predictions = predictionsBySubcode[subCode] ?? []

            // Group by group ("1" or "2")
            var group1Destinations = Set<String>()
            var group1Lines = Set<String>()
            var group2Destinations = Set<String>()
            var group2Lines = Set<String>()

            for p in predictions {
                if p.group == "1" {
                    group1Destinations.insert(p.destination)
                    group1Lines.insert(p.line)
                } else if p.group == "2" {
                    group2Destinations.insert(p.destination)
                    group2Lines.insert(p.line)
                }
            }

            // If no predictions were found for this subcode, use fallback lines derived from station lines
            let subCodeLines = group1Lines.union(group2Lines)
            let activeLines = subCodeLines.isEmpty ? Set(station.lineCodes) : subCodeLines
            let linePrefix = lineGroupName(for: activeLines)

            if !group1Destinations.isEmpty {
                let destList = Array(group1Destinations).sorted().joined(separator: " / ")
                options.append(TrackingOption(
                    directionGroup: "1",
                    label: "\(linePrefix): Towards \(destList)",
                    lines: Array(group1Lines)
                ))
            }

            if !group2Destinations.isEmpty {
                let destList = Array(group2Destinations).sorted().joined(separator: " / ")
                options.append(TrackingOption(
                    directionGroup: "2",
                    label: "\(linePrefix): Towards \(destList)",
                    lines: Array(group2Lines)
                ))
            }
        }

        if options.isEmpty {
            return buildFallbackOptions(for: station)
        }
        return options
    }

    private static func lineGroupName(for lines: Set<String>) -> String {
        let sortedLines = Array(lines).sorted()
        let names = sortedLines.map { code -> String in
            switch code.uppercased() {
            case "RD": return "Red"
            case "OR": return "Orange"
            case "YL": return "Yellow"
            case "GR": return "Green"
            case "BL": return "Blue"
            case "SV": return "Silver"
            default: return code
            }
        }
        return names.joined(separator: "/")
    }

    private static func buildFallbackOptions(for station: Station) -> [TrackingOption] {
        let subCodes = station.id.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
        var options: [TrackingOption] = []

        for subCode in subCodes {
            let lines: [String]
            if subCode == "A01" || subCode.hasPrefix("A") || subCode.hasPrefix("B") {
                lines = ["RD"]
            } else {
                lines = station.lineCodes.filter { $0 != "RD" }
            }

            if !lines.isEmpty {
                let linePrefix = lineGroupName(for: Set(lines))
                options.append(TrackingOption(directionGroup: "1", label: "\(linePrefix): Direction 1", lines: lines))
                options.append(TrackingOption(directionGroup: "2", label: "\(linePrefix): Direction 2", lines: lines))
            }
        }

        if options.isEmpty {
            let lines = station.lineCodes
            if !lines.isEmpty {
                let linePrefix = lineGroupName(for: Set(lines))
                options = [
                    TrackingOption(directionGroup: "1", label: "\(linePrefix): Direction 1", lines: lines),
                    TrackingOption(directionGroup: "2", label: "\(linePrefix): Direction 2", lines: lines),
                ]
            }
        }

        return options
    }
}
