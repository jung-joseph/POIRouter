//
//  ContentView.swift
//  SwiftUIMap
//
//  Created by Joseph Jung on 7/31/22.
//
// https://www.youtube.com/watch?v=6AJQXPDTVTI

import SwiftUI
import MapKit
import Foundation

struct ContentView: View {
    
    @State private var search: String = ""
    //    @State private var showLandmarksSheet = false
    @State  private var showSearchResultsList = false
    @EnvironmentObject var userSettings: UserSettings
    
    @EnvironmentObject var searchVM: SearchResultsViewModel
    
    @EnvironmentObject var appState: AppState
    
    
    
    
    
    //
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.blue]
        
    }
    
    var body: some View {
        NavigationView{
            
            VStack(){

                TextField("Search", text: $search)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        
                        DispatchQueue.main.async {
                            
                            searchVM.search(query: search) {   landmarks in
                                appState.landmarks = landmarks
                            }
                        }
                        
                        showSearchResultsList.toggle()
                        
                    }.padding()
                    .sheet(isPresented: $showSearchResultsList) {
                        SearchResultsList(landmarks: appState.landmarks, showSearchResultsList: $showSearchResultsList) { landmark in
                            appState.selectedLandmark = landmark
                        }
                        .presentationDetents([.large, .medium, .fraction(0.75), .fraction(0.25)])
    
                    }
                
                //                MapView(annotations: appState.landmarks,selectedLandmark: appState.selectedLandmark)
                MapScreen()
                
                Spacer()
                
            } // VStack
//                        .edgesIgnoringSafeArea(.all)
            
            .navigationBarTitle("POIRouter")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    PreferencesButton(destination: PreferencesScreen(userSettings: userSettings))
                        .foregroundColor(Color.blue)
                }
            }//Toolbar
        }//Nav View
    }//body
}//Content View


struct PreferencesButton<Destination : View>: View {
    var destination: Destination
    var body: some View {
        HStack{
            NavigationLink(destination: self.destination){Image(systemName: "gear")}
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let userSettings = UserSettings()
        let appState = AppState()
        let searchVM = SearchResultsViewModel()
        ContentView()
            .environmentObject(appState)
            .environmentObject(searchVM)
            .environmentObject(userSettings)
    }
}
