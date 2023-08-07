//
//  TRIData.swift
//  SCIVisualiser
//
//  Created by Anup D'Souza on 04/08/23.
//

import Foundation
import FirebaseFirestoreSwift

internal struct TRIData: Identifiable, Codable {
    @DocumentID var id: String?
    let date: String
    let value: Double
}
