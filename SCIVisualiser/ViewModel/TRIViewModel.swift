//
//  TRIViewModel.swift
//  SCIVisualiser
//
//  Created by Anup D'Souza on 02/08/23.
//

import Foundation

final class TRIViewModel: ObservableObject {

    @Published var loadingState: LoadingState = .loading
    private let dataManager = DataManager()
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
        dataManager.fetchTRIValue { [weak self] value in
            guard let self else { return }
            guard let value, self.triConfig.start...self.triConfig.end ~= value else {
                self.loadingState = .failure
                return
            }
            self.loadingState = .success((value, self.triLevels))
        }
    }
}
