//
//  SCIViewModel.swift
//  SCIVisualiser
//
//  Created by Anup D'Souza on 02/08/23.
//

import Foundation

internal struct TRIModel {
    let level: Float
    let levelColor: String
    let levelLowerBound: Float
}

internal enum TRIFetchStatus {
    case loading
    case success
    case failure
}

final class SCIViewModel: ObservableObject {
    @Published var tri: Float? = nil
    @Published var triFetchStatus: TRIFetchStatus = .loading
    private var dataLoader = SCIDataLoader()
    
    let triLevels: [TRIModel] = [
        TRIModel(level: 1.40, levelColor: "#ecb576", levelLowerBound: 1.31),
        TRIModel(level: 1.30, levelColor: "#f2cda2", levelLowerBound: 1.21),
        TRIModel(level: 1.20, levelColor: "#f8e4d0", levelLowerBound: 1.11),
        TRIModel(level: 1.10, levelColor: "#ffffff", levelLowerBound: 1.01),
        TRIModel(level: 1.0, levelColor: "#ffffff", levelLowerBound: 0.91),
        TRIModel(level: 0.90, levelColor: "#dce9d5", levelLowerBound: 0.81),
        TRIModel(level: 0.80, levelColor: "#bdd5ac", levelLowerBound: 0.71),
        TRIModel(level: 0.70, levelColor: "#9dc284", levelLowerBound: 0.61),
        TRIModel(level: 0.60, levelColor: "#ffffff", levelLowerBound: 0.51)
    ]
    
    func fetchTRIData() {
        self.triFetchStatus = .loading
        dataLoader.fetchLatestTRI {[weak self] value in
            if 0.6...1.40 ~= value {
                self?.tri = value
                self?.triFetchStatus = .success
            } else {
                self?.tri = nil
                self?.triFetchStatus = .failure
            }
        }
    }
}
