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
    var body: some View {
        VStack{
            
            TextField("Search", text: $search)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    // search nearby places
                    localSearchService.search(query: search)
                }.padding()
            
            if localSearchService.landmarks.isEmpty {
                Text("Your Dog Park Awaits!")
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 16)
                        .stroke(.gray,lineWidth: 2))
            }
            LandmarkListView()
            
            
            Map(coordinateRegion: $localSearchService.region, showsUserLocation: true, annotationItems: localSearchService.landmarks) { landmark in
                
                MapAnnotation(coordinate: landmark.coordinate){
                    Image(systemName: "heart.fill")
                        .foregroundColor(localSearchService.landmark == landmark ? .purple:.red)
                        .scaleEffect(localSearchService.landmark == landmark ? 2: 1)
                }
                
            }
            
            Spacer()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(LocalSearchService())
    }
}
