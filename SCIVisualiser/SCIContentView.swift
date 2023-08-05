//
//  SCIContentView.swift
//  SCIVisualiser
//
//  Created by Anup D'Souza on 02/08/23.
//

import SwiftUI
import FirebaseAnalyticsSwift

struct SCIContentView: View {
    
    private let titleText = "Small Cap Investing Visualiser"
    private let disclaimerText = "Disclaimer: The illustration presented in this app is for information only and is not meant to be used as financial advice. We assume no responsibility or liability for any damages or losses of any kind occurring out of use of the information presented which is provided on an \"as is\" basis with no guarantees of completeness, accuracy, usefulness or timeliness."
    private let errorText = "There was an error fetching TRI data.\nPlease try again after sometime or tap the Refresh button to try now."
    private let refreshButtonTitle = "Refresh"
    
    @StateObject private var viewModel = SCIViewModel(rangeStart: 0.6,
                                                      rangeEnd: 1.4,
                                                      rangeIncrement: 0.1,
                                                      rangeColors: [
                                                        "#ffffff", "#9dc284", "#bdd5ac", "#dce9d5", "#ffffff", "#ffffff", "#f8e4d0", "#f2cda2", "#ecb576"
                                                      ])
    
    var body: some View {
        titleView()
            .onAppear {
                viewModel.fetchTRIData()
            }
            .analyticsScreen(name: "\(SCIContentView.self)")
        Spacer()
        switch viewModel.triFetchStatus {
        case .loading:
            loadingView()
            disclaimerView()
        case .success:
            successView()
        case .failure:
            failureView()
            disclaimerView()
        }
    }
    
    @ViewBuilder private func titleView() -> AnyView {
        AnyView(
            Text(titleText)
        )
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
                Text("Fetching TRI data, please wait...")
                    .font(.callout)
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .analyticsScreen(name: "loadingView")
        )
    }
    
    @ViewBuilder private func successView() -> AnyView {
        AnyView(
            VStack(spacing: 0) {
                ForEach(viewModel.triLevels, id: \.level) { model in
                    VStack {
                        HStack {
                            Text(String(format: "%.2f", model.level))
                            Spacer()
                        }
                        if let currentTRI = viewModel.latestTRI,
                           model.levelLowerBound...model.level ~= currentTRI {
                            Text(String(format: "Current TRI is %.2f", currentTRI))
                                .fontWeight(.light)
                            Spacer()
                        } else {
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(hex: model.levelColor))
                }
            }
                .analyticsScreen(name: "successView")
        )
    }
    
    @ViewBuilder private func failureView() -> AnyView {
        AnyView(
            VStack {
                Text(errorText)
                    .font(.callout)
                    .multilineTextAlignment(.center)
                Button(refreshButtonTitle) { [weak viewModel] in
                    viewModel?.fetchTRIData()
                }
                .buttonStyle(.bordered)
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .analyticsScreen(name: "failureView")
        )
    }
}

struct SCIContentView_Previews: PreviewProvider {
    static var previews: some View {
        SCIContentView()
    }
}
