//
//  SwiftUIMapApp.swift
//  SwiftUIMap
//
//  Created by Joseph Jung on 7/31/22.
//

import SwiftUI

@main
struct POIRouterApp: App {
    @StateObject var userSettings = UserSettings()
    
    var body: some Scene {
        WindowGroup {
            //            let appState = AppState()
            ContentView(userSettings: userSettings)
                .environmentObject(LocalSearchService())
                .preferredColorScheme(userSettings.isDarkMode ? .dark : .light)
            
        }
    }
}
