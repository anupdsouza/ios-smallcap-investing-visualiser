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

    @Published var latestTRI: Double? = nil
    @Published var triFetchStatus: TRIFetchStatus = .loading
    private var dataLoader = SCIDataLoader()
    private var db = Firestore.firestore()
    private let collectionPath = "TRIValues"
    
    private let rangeStart: Double
    private let rangeEnd: Double
    private let rangeIncrement: Double
    private let rangeColors: [String]

    init(rangeStart: Double, rangeEnd: Double, rangeIncrement: Double, rangeColors: [String]) {
        self.rangeStart = rangeStart
        self.rangeEnd = rangeEnd
        self.rangeIncrement = rangeIncrement
        self.rangeColors = rangeColors
    }
    
    lazy var triLevels: [TRILevel] = {
        var levels = [TRILevel]()
        var index = 0
        while index < rangeColors.count {
            for value in stride(from: rangeStart, through: rangeEnd, by: rangeIncrement) {
                levels.append(TRILevel(levelUpperBound: value, levelLowerBound: value - rangeIncrement, levelColor: rangeColors[index]))
                index += 1
            }
        }
        levels.sort { $0.levelUpperBound > $1.levelUpperBound }
        return levels
    }()
    
    func fetchTRIData() {
        self.triFetchStatus = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.latestTRI = 1.25
            self?.triFetchStatus = .success
        }
//        db.collection(collectionPath).addSnapshotListener {[weak self] querySnapshot, error in
//
//            guard let documents = querySnapshot?.documents,
//                  let triData = documents.compactMap({ queryDocumentSnapshot -> TRIData? in
//                      return try? queryDocumentSnapshot.data(as: TRIData.self)
//                  }).first,
//                  triData.date == self?.dataLoader.triRequestDate().replacingOccurrences(of: "-", with: " ") else {
//                self?.fetchLatestTRI()
//                return
//            }
//
//            self?.latestTRI = triData.tri
//            self?.triFetchStatus = .success
//        }
    }

    private func fetchLatestTRI() {
        dataLoader.fetchLatestTRI {[weak self] triData in
            guard let self else { return }
            guard let triData, self.rangeStart...self.rangeEnd ~= triData.tri else {
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
