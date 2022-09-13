//
//  SearchResultsList.swift
//  POIRouter
//
//  Created by Joseph Jung on 9/9/22.
//

import SwiftUI
import MapKit

struct SearchResultsList: View {
    
    
    let landmarks: [LandmarkAnnotation]
    var onSelect: (LandmarkAnnotation) -> Void
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var localSearchService: LocalSearchService
    @StateObject private var locationManager = LocationManager()
    //    @Binding var showSearchResultsList: Bool
    
    var distanceFormatter = DistanceFormatter()
    
    init(landmarks: [LandmarkAnnotation], onSelect: @escaping(LandmarkAnnotation)-> Void) {
        self.landmarks = landmarks
        self.onSelect = onSelect
    }
    
    func formatDistance(for landmark: LandmarkAnnotation) -> String {
        //        print("location  \(locationManager.location)")
        guard let distanceInMeters = landmark.getDistance(userLocation: locationManager.location) else {return ""}
        distanceFormatter.unitOptions = userSettings.distanceUnit
        return distanceFormatter.format(distanceInMeters: distanceInMeters)
    }
    
    var body: some View {
        List(landmarks) { landmark in
            VStack(alignment: .leading) {
                Text(landmark.title ?? "")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(landmark.city)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(formatDistance(for:landmark))
                    .font(.caption)
                    .opacity(0.4)
            }//VStack
            // .listRowBackground(localSearchService.landmark == landmark ?? Color(UIColor.lightGray): Color.white)
            .contentShape(Rectangle())
            .onTapGesture {
                onSelect(landmark)
                withAnimation{
                localSearchService.region = MKCoordinateRegion.regionFromLandmark(landmark)
                }
            }
            
        }// List
    }
}

struct SearchResultsList_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsList(landmarks: [], onSelect: {_ in })
    }
}
