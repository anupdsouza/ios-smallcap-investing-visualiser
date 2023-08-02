//
//  SCIDataLoader.swift
//  SCIVisualiser
//
//  Created by Anup D'Souza on 02/08/23.
//

import Foundation
import Combine

struct StockIndex: Codable {
    let indexName: String
    let date: String
    let totalReturnsIndex: String
    
    enum CodingKeys: String, CodingKey {
        case indexName = "Index Name"
        case date = "Date"
        case totalReturnsIndex = "TotalReturnsIndex"
    }
}

struct ResponseContainer: Codable {
    let d: String
}

class SCIDataLoader {
    private let NIFTY50_SYMBOL = "NIFTY 50"
    private let NIFTYSMALLCAP250_SYMBOL = "NIFTY SMLCAP 250"
    private let urlString = "https://www.niftyindices.com/Backpage.aspx/getTotalReturnIndexString"
    private var cancellables = Set<AnyCancellable>()

    func fetchLatestTRI(completion: @escaping (_ value: Float) -> ()) {
        let niftyPublisher = fetchTRIData(requestBody: niftyPOSTBody())
        let smallcapPublisher = fetchTRIData(requestBody: smallcapPOSTBody())
        
        Publishers.Zip(niftyPublisher, smallcapPublisher)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { niftyValues, smallcapValues in
                
                let smallcapInitialTRI = 2100.00
                let niftyInitialTRI = 4807.77
                
                var relativeValue: Float = 0.0
                
                guard let smallcapValues = smallcapValues, let niftyValues = niftyValues else {
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
    
    private func niftyPOSTBody() -> [String: String] {
        return [
          "name" : NIFTY50_SYMBOL,
          "startDate" : "01-Aug-2023",
          "endDate" : "01-Aug-2023"
        ]
    }
    
    private func smallcapPOSTBody() -> [String: String] {
        return [
          "name" : NIFTYSMALLCAP250_SYMBOL,
          "startDate" : "01-Aug-2023",
          "endDate" : "01-Aug-2023"
        ]
    }
}
