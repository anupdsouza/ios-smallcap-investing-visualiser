//
//  SCIVisualiserApp.swift
//  SCIVisualiser
//
//  Created by Anup D'Souza on 02/08/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

struct StartView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Spacer()
                disclaimerView()
                NavigationLink(StringConstants.acceptNavigationText) {
                    ContentView()
                }.buttonStyle(.bordered)
                Spacer()
            }
            .navigationTitle(StringConstants.startTitleText)
        }
    }
    
    @ViewBuilder private func disclaimerView() -> AnyView {
        AnyView(
            VStack(alignment: .leading, spacing: 0) {
                Text(StringConstants.disclaimerText)
                    .font(.title2)
                    .padding(.bottom, 5)
                Text(StringConstants.disclaimerSubText)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
            }.padding(20)
        )
    }
}

@main
struct SCIVisualiserApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            StartView()
        }
    }
}
