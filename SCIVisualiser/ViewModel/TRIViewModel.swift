//
//  TRIViewModel.swift
//  SCIVisualiser
//
//  Created by Anup D'Souza on 02/08/23.
//

import Foundation
import FirebaseFirestore

final class TRIViewModel: ObservableObject {

    @Published var loadingState: LoadingState = .loading
    private var dataLoader = DataLoader()
    // TODO: Move db stuff to Data Manager
    private var db = Firestore.firestore()
    private let collectionPath = "TRIValues"
    
    private lazy var triConfig: TRIConfig = {
        let colors = ["#d1fab6", "#d9fac3", "#e0facf", "#e9fade", "#ebf5fc", "#ebf5fc", "#ffefd9", "#fce8cc", "#fce3c0", "#fcdeb3"]
        return .init(start: 0.6, end: 1.5, step: 0.1, colors: colors)
    }()

    private lazy var triLevels: [TRILevel] = {
        var levels = [TRILevel]()
        var index = 0
        while index < triConfig.colors.count {
            for value in stride(from: triConfig.start, through: triConfig.end, by: triConfig.step) {
                levels.append(TRILevel(upperValue: value, lowerValue: value - triConfig.step, color: triConfig.colors[index]))
                index += 1
            }
        }
        levels.sort { $0.upperValue > $1.upperValue }
        return levels
    }()
    
    func fetchTRIData() {
        self.loadingState = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            guard let self else { return }
            self.loadingState = .success((1.25, self.triLevels))
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
//            self.loadingState = .success((triData.tri, self.triLevels))
//        }
    }

    private func fetchLatestTRI() {
        dataLoader.fetchLatestTRI {[weak self] triData in
            guard let self else { return }
            guard let triData, self.triConfig.start...self.triConfig.end ~= triData.value else {
                self.loadingState = .failure
                return
            }
            self.loadingState = .success((triData.value, self.triLevels))
            
            do {
                let _ = try self.db.collection(self.collectionPath).addDocument(from: triData)
            }
            catch {
                print(error)
            }
        }
    }
}
