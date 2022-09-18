//
//  MapView.swift
//  POIRouter
//
//  Created by Joseph Jung on 9/8/22.
//

import Foundation
import MapKit
import SwiftUI
import UIKit

struct MapView: UIViewRepresentable {
    
    typealias UIViewType = MKMapView
    
    private var annotations: [LandmarkAnnotation] = []
    private var selectedLandmark: LandmarkAnnotation?

    init(annotations: [LandmarkAnnotation], selectedLandmark: LandmarkAnnotation?) {
        self.annotations = annotations
        self.selectedLandmark = selectedLandmark
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.showsUserLocation = true
        map.delegate = context.coordinator
        map.mapType = .hybrid
        return map
    }
    
    func updateUIView(_ map: MKMapView, context: Context) {
        // remove all annotations
        map.removeAnnotations(map.annotations)
        
        // reset selectedLandmark
//        map.deselectAnnotation(selectedLandmark, animated: true)
        
        if !map.overlays.isEmpty {
            print("overlays is not Empty")
            map.removeOverlays(map.overlays)

        }
        
        // register annotations
        registerMapAnnotations(map: map)
        
        // add annotations
        map.addAnnotations(annotations)
        
        if let selectedLandmark = selectedLandmark {
            map.selectAnnotation(selectedLandmark, animated: true)
        }
        
        //update region
      
    }
    
    private func registerMapAnnotations(map: MKMapView) {
        print("registering  \(annotations.count) annotations")
        
        for annotation in annotations {
            map.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: annotation.title ?? "")
        }

        
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
}
