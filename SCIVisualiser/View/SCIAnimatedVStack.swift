//
//  SCIAnimatedVStack.swift
//  SCIVisualiser
//
//  Created by Anup D'Souza on 06/08/23.
//

import SwiftUI

struct SCIAnimatedVStack: View {
    let index: Int
    let level: TRILevel
    let viewModel: SCIViewModel
    @State private var isVisible = false
    @State private var isTextVisible = false
    
    var body: some View {
        VStack {
            if isVisible {
                HStack {
                    Text(String(format: "%.2f", level.levelUpperBound))
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
                if let currentTRI = viewModel.latestTRI,
                   currentTRI > level.levelLowerBound && currentTRI <= level.levelUpperBound {
                    Text(String(format: "Current TRI is %.2f", currentTRI))
                        .fontWeight(.light)
                        .shadow(color: .white, radius: 2.0, y: 1.0)
                    Spacer()
                } else {
                    Spacer()
                }
            }
        }
        .clipped()
        .background(Color(hex: level.levelColor))
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
