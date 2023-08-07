//
//  TRILevelView.swift
//  SCIVisualiser
//
//  Created by Anup D'Souza on 06/08/23.
//

import SwiftUI

internal struct TRILevelView: View {

    let index: Int
    let level: TRILevel
    let currentTRIValue: Double
    @State private var isVisible = false
    @State private var isTextVisible = false
    
    var body: some View {
        VStack {
            if isVisible {
                HStack {
                    Text(String(format: "%.2f", level.upperValue))
                        .offset(y: isTextVisible ? 0 : -50)
                        .opacity(isTextVisible ? 1 : 0)
                        .animation(.easeInOut(duration: 0.5), value: isTextVisible)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                isTextVisible = true
                            }
                        }
                    Spacer()
                }
                if currentTRIValue > level.lowerValue && currentTRIValue <= level.upperValue {
                    Text(String(format: "Current TRI is %.2f", currentTRIValue))
                        .fontWeight(.light)
                }
                Spacer()
            }
        }
        .clipped()
        .background(Color(hex: level.color))
        .offset(x: isVisible ? 0 : -UIScreen.main.bounds.self.width)
        .opacity(isVisible ? 1 : 0)
        .transition(.slide)
        .animation(.easeInOut(duration: 0.5), value: isVisible)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                isVisible = true
            }
        }
    }
}
