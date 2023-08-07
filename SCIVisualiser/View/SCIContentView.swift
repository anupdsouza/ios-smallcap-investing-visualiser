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
                                                      rangeEnd: 1.50,
                                                      rangeIncrement: 0.10,
                                                      rangeColors: [
                                                        "#d1fab6", "#d9fac3", "#e0facf", "#e9fade", "#ebf5fc", "#ebf5fc", "#ffefd9", "#fce8cc", "#fce3c0", "#fcdeb3"
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
                ForEach(0..<viewModel.triLevels.count, id:\.self) { index in
                    let level = viewModel.triLevels[index]
                    SCIAnimatedVStack(index: index, level: level, viewModel: viewModel)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
