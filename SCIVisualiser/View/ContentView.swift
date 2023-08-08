//
//  ContentView.swift
//  SCIVisualiser
//
//  Created by Anup D'Souza on 02/08/23.
//

import SwiftUI
import FirebaseAnalyticsSwift

struct ContentView: View {

    @StateObject private var viewModel = TRIViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            switch viewModel.loadingState {
            case .loading:
                loadingView()
            case .success((let triValue, let triLevels)):
                triViewWithTRI(triValue, triLevels: triLevels)
            case .failure:
                failureView()
            }
        }
        .navigationTitle(StringConstants.titleText)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { [weak viewModel] in
            viewModel?.fetchTRIData()
        }
        .analyticsScreen(name: "\(ContentView.self)")
    }
    
    @ViewBuilder private func loadingView() -> AnyView {
        AnyView(
            VStack {
                Text(StringConstants.loadingText)
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .analyticsScreen(name: AnalyticsConstants.loadingView)
        )
    }
    
    @ViewBuilder private func triViewWithTRI(_ triValue: Double, triLevels levels: [TRILevel]) -> AnyView {
        AnyView(
            VStack(spacing: 0) {
                ForEach(0..<levels.count, id:\.self) { index in
                    TRILevelView(index: index, level: levels[index], currentTRIValue: triValue)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
                .analyticsScreen(name: AnalyticsConstants.triView)
        )
    }
    
    @ViewBuilder private func failureView() -> AnyView {
        AnyView(
            VStack {
                Text(StringConstants.failureText)
                    .multilineTextAlignment(.leading)
                    .padding(20)
                Button(StringConstants.refreshButtonText) {
                    viewModel.fetchTRIData()
                }
                .buttonStyle(.bordered)
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .analyticsScreen(name: AnalyticsConstants.failureView)
        )
    }
}

struct SCIContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
