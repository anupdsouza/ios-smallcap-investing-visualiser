//
//  SCIViewModel.swift
//  SCIVisualiser
//
//  Created by Anup D'Souza on 02/08/23.
//

import Foundation

class SCIViewModel: ObservableObject {
    
    @Published var totalReturnsIndex: String = "Fetching TRI..."
    private var dataLoader = SCIDataLoader()
    
    func fetchTRIData() {
        dataLoader.fetchLatestTRI {[weak self] value in
            if value > 0 {
                self?.totalReturnsIndex = String(format: "TRI is %.2f", value)
            } else {
                self?.totalReturnsIndex = "Error fetching TRI"
            }
        }
    }
}
