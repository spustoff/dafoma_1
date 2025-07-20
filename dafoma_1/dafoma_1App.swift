//
//  dafoma_2App.swift
//  AviGrid Studio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

@main
struct AviGridStudioApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appState)
                .preferredColorScheme(.dark)
        }
    }
}
