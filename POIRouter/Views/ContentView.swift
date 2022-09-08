//
//  ContentView.swift
//  SwiftUIMap
//
//  Created by Joseph Jung on 7/31/22.
//
// https://www.youtube.com/watch?v=6AJQXPDTVTI

import SwiftUI
import MapKit

struct ContentView: View {
   
    @EnvironmentObject var localSearchService: LocalSearchService
    @State private var search: String = ""
    @State private var showLandmarksSheet = false
    @ObservedObject var userSettings: UserSettings
    //
    init(userSettings: UserSettings) {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.blue]
        self.userSettings = userSettings
    }
    
    var body: some View {
        NavigationView{
            
            VStack(){
                TextField("Search", text: $search)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        // search nearby places
                        localSearchService.search(query: search)
                        showLandmarksSheet.toggle()
                    }.padding()
                HStack{
                    Button(action: {
                        localSearchService.search(query: search)
                        showLandmarksSheet.toggle()
                    }
                           , label: {Text("Destination")})
                    .background(Color.green)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .font(.custom("Arial", size: 18))
                    .sheet(isPresented: $showLandmarksSheet) {
                        LandmarkListView(showLandmarksSheet: $showLandmarksSheet)
                        //                                .presentationDetents([.medium, .large]) //     Need Xcode 14
                        
                    }
                    
                    
                    
                    Button(action: {
                        localSearchService.search(query: search)
                        showLandmarksSheet.toggle()
                    }) {Text("POI's")}
                        .background(Color.green)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .font(.custom("Arial", size: 18))
                        .sheet(isPresented: $showLandmarksSheet) {
                            LandmarkListView(showLandmarksSheet: $showLandmarksSheet)
                            //                            .presentationDetents([.medium, .large])//     Need Xcode 14
                            
                        }
                    //
                }
                
                Map(coordinateRegion: $localSearchService.region, showsUserLocation: true, annotationItems: localSearchService.landmarks) { landmark in
                    
                    MapAnnotation(coordinate: landmark.coordinate){
                        //                    Image(systemName: "heart.fill")
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(localSearchService.landmark == landmark ? .purple:.red)
                            .scaleEffect(localSearchService.landmark == landmark ? 2: 1)
                    }
                    
                    
                }
                
                Spacer()
                
            }
            //            .edgesIgnoringSafeArea(.all)
            
            .navigationBarTitle("POIRouter")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    PreferencesButton(destination: PreferencesScreen(userSettings: userSettings))
                        .foregroundColor(Color.blue)
                }
            }
            
        }
        
    }
}

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
        ContentView(userSettings: UserSettings()).environmentObject(LocalSearchService())
    }
}
