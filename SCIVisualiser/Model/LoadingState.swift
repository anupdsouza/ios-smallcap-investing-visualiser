//
//  LoadingState.swift
//  SCIVisualiser
//
//  Created by Anup D'Souza on 07/08/23.
//

import Foundation

internal enum LoadingState {
    case loading
    case success ((Double, [TRILevel]))
    case failure
}
