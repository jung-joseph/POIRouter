//
//  SwiftUIMapApp.swift
//  SwiftUIMap
//
//  Created by Joseph Jung on 7/31/22.
//

import SwiftUI

@main
struct POIRouterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(LocalSearchService())
        }
    }
}
