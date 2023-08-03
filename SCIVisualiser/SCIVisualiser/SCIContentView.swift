//
//  SCIContentView.swift
//  SCIVisualiser
//
//  Created by Anup D'Souza on 02/08/23.
//

import SwiftUI

struct SCIContentView: View {
    
    private let titleText = "Small Cap Investing Visualiser"
    private let disclaimerText = "Disclaimer: The illustration presented in this app is for information only and is not meant to be used as financial advice. We assume no responsibility or liability for any damages or losses of any nature occurring out of use of the information presented which is provided on an \"as is\" basis with no guarantees of completeness, accuracy, usefulness or timeliness."
    private let errorText = "There was an error fetching TRI data.\nPlease try again after sometime or tap the Refresh button to try now."
    private let refreshButtonTitle = "Refresh"
    
    @StateObject var viewModel = SCIViewModel()
    
    var body: some View {
            titleView()
                .onAppear {
                    viewModel.fetchTRIData()
                }
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
                        if let currentTRI = viewModel.tri,
                           model.levelLowerBound...model.level ~= currentTRI {
                            Text(String(format: "Current TRI is %.2f", currentTRI))
                                .fontWeight(.light)
                            Spacer()
                        } else {
                            Spacer()
                        }
                    }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.colorWithHexString(model.levelColor))
                }
            }
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
        )
    }
}

struct SCIContentView_Previews: PreviewProvider {
    static var previews: some View {
        SCIContentView()
    }
}
