//
//  DataManager.swift
//  SCIVisualiser
//
//  Created by Anup D'Souza on 07/08/23.
//

import Foundation
import FirebaseFirestore

final class DataManager {

    private let collectionPath = "TRIValues"
    private let dataLoader = DataLoader()
    private var db = Firestore.firestore()
    typealias Completion = (_ value: Double?) -> ()

    func fetchTRIValue(_ completion: @escaping Completion) {

        db.collection(collectionPath).addSnapshotListener { [weak self] querySnapshot, error in
            guard let self else { return }
            guard let documents = querySnapshot?.documents,
                  let triData = documents.compactMap({ queryDocumentSnapshot -> TRIData? in
                      return try? queryDocumentSnapshot.data(as: TRIData.self)
                  }).first,
                  triData.date == self.dataLoader.triRequestDate().replacingOccurrences(of: "-", with: " ") else {
                self.fetchLatestTRI(completion)
                return
            }
            completion(triData.value)
        }
    }
    
    private func storeTRIValue(_ triData: TRIData) {
        do {
            let _ = try db.collection(collectionPath).addDocument(from: triData)
        }
        catch { print(error) }
    }
    
    private func fetchLatestTRI(_ completion: @escaping Completion) {
        dataLoader.fetchLatestTRI { [weak self] triData in
            guard let self else { return }
            guard let triData else {
                completion(nil)
                return
            }
            self.storeTRIValue(triData)
            completion(triData.value)
        }
    }
}
