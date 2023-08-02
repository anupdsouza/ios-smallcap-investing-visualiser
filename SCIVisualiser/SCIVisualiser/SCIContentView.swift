//
//  SCIContentView.swift
//  SCIVisualiser
//
//  Created by Anup D'Souza on 02/08/23.
//

import SwiftUI

struct SCIContentView: View {
    
    @StateObject var viewModel = SCIViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(viewModel.totalReturnsIndex)
        }
        .padding()
        .onAppear {
            viewModel.fetchTRIData()
        }
    }
}

struct SCIContentView_Previews: PreviewProvider {
    static var previews: some View {
        SCIContentView()
    }
}
