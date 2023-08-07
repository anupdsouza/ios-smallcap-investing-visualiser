//
//  ContentView.swift
//  SCIVisualiser
//
//  Created by Anup D'Souza on 02/08/23.
//

import SwiftUI
import FirebaseAnalyticsSwift

struct ContentView: View {
    
    private let titleText = "Small Cap Investing Visualiser"
    private let loadingText = "Fetching TRI data, please wait..."
    private let refreshButtonText = "Refresh"
    private let disclaimerText = "Disclaimer: The illustration presented in this app is for information only and is not meant to be used as financial advice. We assume no responsibility or liability for any damages or losses of any kind occurring out of use of the information presented which is provided on an \"as is\" basis with no guarantees of completeness, accuracy, usefulness or timeliness."
    private let errorText = "There was an error fetching TRI data.\nPlease try again after sometime or tap the Refresh button to try now."

    @StateObject private var viewModel = TRIViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                switch viewModel.loadingState {
                case .loading:
                    loadingView()
                    disclaimerView()
                case .success((let triValue, let triLevels)):
                    triViewWithTRI(triValue, triLevels: triLevels)
                case .failure:
                    failureView()
                    disclaimerView()
                }
            }
            .navigationTitle(titleText)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchTRIData()
            }
        }
        .analyticsScreen(name: "\(ContentView.self)")
    }
    
    @ViewBuilder private func disclaimerView() -> AnyView {
        AnyView(
            Text(disclaimerText)
                .font(.footnote)
                .multilineTextAlignment(.center)
                .padding(20)
        )
    }
    
    @ViewBuilder private func loadingView() -> AnyView {
        AnyView(
            VStack {
                Text(loadingText)
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
                Text(errorText)
                    .multilineTextAlignment(.center)
                Button(refreshButtonText) {
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
