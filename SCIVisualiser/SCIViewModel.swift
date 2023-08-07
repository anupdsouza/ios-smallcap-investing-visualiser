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
    
    private let rangeStart: Float
    private let rangeEnd: Float
    private let rangeIncrement: Float
    private let rangeColors: [String]

    init(rangeStart: Float, rangeEnd: Float, rangeIncrement: Float, rangeColors: [String]) {
        self.rangeStart = rangeStart
        self.rangeEnd = rangeEnd
        self.rangeIncrement = rangeIncrement
        self.rangeColors = rangeColors
    }
    
    lazy var triLevels: [TRILevel] = {
        var start = rangeStart
        var levels = [TRILevel]()
        while start < (rangeEnd + 0.01) {
            print(start)
            levels.append(TRILevel(level: start, levelColor: "", levelLowerBound: start - rangeIncrement + 0.01))
            start += rangeIncrement
            print(start)
        }
        levels.sort { $0.level > $1.level }        
        return levels
    }()
    
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
