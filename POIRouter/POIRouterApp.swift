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
    @StateObject var appState = AppState()
    @StateObject var searchVM = SearchResultsViewModel()
    @StateObject var localSearchService = LocalSearchService()
    var body: some Scene {
        
        WindowGroup {
            
            ContentView()
                .environmentObject(appState)
                .environmentObject(searchVM)
                .environmentObject(userSettings)
                .environmentObject(localSearchService)
                .preferredColorScheme(userSettings.isDarkMode ? .dark : .light)


            
        }
    }
}
