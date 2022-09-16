//
//  MapViewCoordinator.swift
//  POIRouter
//
//  Created by Joseph Jung on 9/8/22.
//

import Foundation
import MapKit
import UIKit

final class MapViewCoordinator: NSObject, MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        
        guard let annotation = view.annotation as? LandmarkAnnotation else {
            return
        }
        
        view.canShowCallout = true
        
        
//        view.detail
        
        view.detailCalloutAccessoryView = LandmarkCalloutView(annotation: annotation, selectShowDirections: { [weak self]
            place in
            
            let start = MKMapItem.forCurrentLocation()
            let destination = MKMapItem(placemark: MKPlacemark(coordinate: place.coordinate))
            
            self?.calculateRoute(start: start, destination: destination) {route in
                if let route = route {
                    
                    view.detailCalloutAccessoryView = nil
                    
                    let controller = RouteContentViewController(route: route)
                    let routePopover = RoutePopover(controller: controller)
                    
                    let positioningView = UIView(frame: CGRect(x: mapView.frame.width/2.6, y:0, width:
                                                                mapView.frame.width/2, height: 0.0))
//                    view.autoresizesSubviews = true

                    mapView.addSubview(positioningView)
                    
                    // clear all overlays
                    mapView.removeOverlays(mapView.overlays)
                    
                    // add overlay on the map
                    mapView.addOverlay(route.polyline, level: .aboveRoads)
//                    routePopover.show(relativeTo: positioningView.frame, of: positioningView, preferredEdge: .minY)
                    
                    routePopover.show(routePopover, sender: self)
                    
                }
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 5
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let mapPlace = annotation as? LandmarkAnnotation else {return nil}
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "customMapAnnotation") as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "customMapAnnotation")
        
        
        annotationView.canShowCallout = true
//        annotationView.glyphText = "⛳️"
//        annotationView.detailCalloutAccessoryView = UIImage(named: GG).map(UIImageView.init)
        annotationView.detailCalloutAccessoryView = UIImage(systemName: "pencil.and.outline").map(UIImageView.init)

        print("mapPlace \(String(describing: mapPlace.address))")
        
        return annotationView
    }
    func calculateRoute(start: MKMapItem, destination: MKMapItem, completion: @escaping (MKRoute?) -> Void) {
        let directionsRequest = MKDirections.Request()
        directionsRequest.transportType = .automobile
        directionsRequest.source = start
        directionsRequest.destination = destination
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { response, error in
            if let error = error {
                print("Unable to calculate directions \(error)")
            }
            
            guard let response = response,
                  let route = response.routes.first else {
                return
            }
            completion(route)
        }
    }
    
}
