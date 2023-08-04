//
//  SCIViewModel.swift
//  SCIVisualiser
//
//  Created by Anup D'Souza on 02/08/23.
//

import Foundation
import FirebaseFirestore

internal enum TRIFetchStatus {
    case loading
    case success
    case failure
}

final class SCIViewModel: ObservableObject {

    @Published var latestTRI: Float? = nil
    @Published var triFetchStatus: TRIFetchStatus = .loading
    private var dataLoader = SCIDataLoader()
    private var db = Firestore.firestore()
    private let collectionPath = "TRIValues"
    
    let triLevels: [TRILevel] = [
        TRILevel(level: 1.40, levelColor: "#ecb576", levelLowerBound: 1.31),
        TRILevel(level: 1.30, levelColor: "#f2cda2", levelLowerBound: 1.21),
        TRILevel(level: 1.20, levelColor: "#f8e4d0", levelLowerBound: 1.11),
        TRILevel(level: 1.10, levelColor: "#ffffff", levelLowerBound: 1.01),
        TRILevel(level: 1.0, levelColor: "#ffffff", levelLowerBound: 0.91),
        TRILevel(level: 0.90, levelColor: "#dce9d5", levelLowerBound: 0.81),
        TRILevel(level: 0.80, levelColor: "#bdd5ac", levelLowerBound: 0.71),
        TRILevel(level: 0.70, levelColor: "#9dc284", levelLowerBound: 0.61),
        TRILevel(level: 0.60, levelColor: "#ffffff", levelLowerBound: 0.51)
    ]
    
    func fetchTRIData() {
        self.triFetchStatus = .loading
        db.collection(collectionPath).addSnapshotListener {[weak self] querySnapshot, error in
            
            guard let documents = querySnapshot?.documents,
                  let triData = documents.compactMap({ queryDocumentSnapshot -> TRIData? in
                      return try? queryDocumentSnapshot.data(as: TRIData.self)
                  }).first,
                  triData.date == self?.dataLoader.triRequestDate().replacingOccurrences(of: "-", with: " ") else {
                self?.fetchLatestTRI()
                return
            }
            
            self?.latestTRI = triData.tri
            self?.triFetchStatus = .success
        }
    }

    private func fetchLatestTRI() {
        dataLoader.fetchLatestTRI {[weak self] triData in
            guard let self else { return }
            guard let triData, 0.6...1.40 ~= triData.tri else {
                self.triFetchStatus = .failure
                return
            }
            self.latestTRI = triData.tri
            self.triFetchStatus = .success
            
            do {
                let _ = try self.db.collection(self.collectionPath).addDocument(from: triData)
            }
            catch {
                print(error)
            }
        }
    }
}
