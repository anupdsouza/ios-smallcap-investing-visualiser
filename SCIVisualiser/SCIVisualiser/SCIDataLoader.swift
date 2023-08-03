//
//  SCIDataLoader.swift
//  SCIVisualiser
//
//  Created by Anup D'Souza on 02/08/23.
//

import Foundation
import Combine

internal struct StockIndex: Codable {
    let indexName: String
    let date: String
    let totalReturnsIndex: String
    
    enum CodingKeys: String, CodingKey {
        case indexName = "Index Name"
        case date = "Date"
        case totalReturnsIndex = "TotalReturnsIndex"
    }
}

internal struct ResponseContainer: Codable {
    let d: String
}

final class SCIDataLoader {
    private let niftySymbol = "NIFTY 50"
    private let smallcapSymbol = "NIFTY SMLCAP 250"
    private let urlString = "https://www.niftyindices.com/Backpage.aspx/getTotalReturnIndexString"
    private var cancellables = Set<AnyCancellable>()

    func fetchLatestTRI(completion: @escaping (_ value: Float) -> ()) {
        let niftyPublisher = fetchTRIData(requestBody: postBodyFor(niftySymbol))
        let smallcapPublisher = fetchTRIData(requestBody: postBodyFor(smallcapSymbol))
        
        Publishers.Zip(niftyPublisher, smallcapPublisher)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { niftyValues, smallcapValues in
                
                let smallcapInitialTRI = 2100.00
                let niftyInitialTRI = 4807.77
                
                var relativeValue: Float = 0.0
                
                guard let smallcapValues = smallcapValues, let niftyValues = niftyValues else {
                    completion(0)
                    return
                }
                for smallcapObj in smallcapValues {
                    let smallcapDate = smallcapObj.date
                    let smallcapTRI = Double(smallcapObj.totalReturnsIndex) ?? 0.0
                    var niftyTRI: Double = 0.0
                    
                    for niftyObj in niftyValues {
                        let niftyDate = niftyObj.date
                        
                        if niftyDate == smallcapDate {
                            niftyTRI = Double(niftyObj.totalReturnsIndex) ?? 0.0
                            break
                        }
                    }
                    
                    if smallcapTRI != 0.0 && niftyTRI != 0.0 {
                        relativeValue = Float((smallcapTRI / smallcapInitialTRI) / (niftyTRI / niftyInitialTRI))
                        break
                    }
                }
                
                completion(relativeValue)
            })
            .store(in: &cancellables)
    }
    
    func fetchTRIData(requestBody body: [String: String]) -> AnyPublisher<[StockIndex]?, Never> {
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        for (header, val) in requestHeaders() {
            request.addValue(val, forHTTPHeaderField: header)
        }
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: ResponseContainer.self, decoder: JSONDecoder())
            .map { container in
                try? JSONDecoder().decode([StockIndex].self, from: container.d.data(using: .utf8) ?? Data())
            }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    private func requestHeaders() -> [String: String] {
        return [
            "Content-type": "application/json; charset=UTF-8",
            "Accept-Language": "en-GB",
            "Accept": "*/*"
        ]
    }
    
    private func postBodyFor(_ symbol: String) -> [String: String] {
        let date = triRequestDate()
        let body = [
          "name" : symbol,
          "startDate" : date,
          "endDate" : date
        ]
        print(body)
        return body
    }
    
    private func triRequestDate() -> String {
        let today = Date()
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today) else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return dateFormatter.string(from: yesterday)
    }
}
