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
