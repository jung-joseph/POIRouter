//
//  LandmarkListView.swift
//  SwiftUIMap
//
//  Created by Joseph Jung on 7/31/22.
//
import Foundation
import SwiftUI
import MapKit

struct LandmarkListView: View {
    
    @EnvironmentObject var localSearchService: LocalSearchService
    @Binding var showLandmarksSheet: Bool
    @AppStorage("distanceUnit") var distanceUnit: DistanceUnit = .miles
    @StateObject private var locationManager = LocationManager()
    
    var distanceFormatter = DistanceFormatter()

    func formatDistance(for place: Landmark ) -> String {
        
        print("location  \(String(describing: locationManager.location))")

// Albuquerque:
//        let userLocation =  CLLocation(latitude: 35.084385, longitude: -106.650421)
        
// Akron:
//        let userLocation =  CLLocation(latitude: 41.0814, longitude: -81.5190)
        guard let distanceInMeters = place.getDistance(userLocation: locationManager.location) else {return ""}
                distanceFormatter.unitOptions = distanceUnit
                return distanceFormatter.format(distanceInMeters: distanceInMeters)
    }
    var body: some View {
        VStack{
            List(localSearchService.landmarks) {landmark in
                VStack(alignment: .leading){
                    Text(landmark.name)
                    Text(landmark.title)
                        .opacity(0.5)
                    Text(formatDistance(for: landmark))
                        .font(.caption)
                        .opacity(0.5)
                    
                }
                .listRowBackground(localSearchService.landmark == landmark ?
                                   Color(UIColor.lightGray): Color.white)
                .onTapGesture {
                    localSearchService.landmark = landmark
                    withAnimation(.linear(duration: 15))
                    {
                        localSearchService.region = MKCoordinateRegion.regionFromLandmark(landmark)
                            
                    }
                    showLandmarksSheet.toggle()
                }
                
            }
        }
    }
}

struct LandmarkListView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkListView(showLandmarksSheet: .constant(false)).environmentObject(LocalSearchService())
    }
}
