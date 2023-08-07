//
//  StockIndex.swift
//  SCIVisualiser
//
//  Created by Anup D'Souza on 07/08/23.
//

import Foundation

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
