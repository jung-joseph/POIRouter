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
        
        print("in Did Select \(String(describing: annotation.title))")

        view.canShowCallout = true
        
        
//        view.detail
        
//        view.detailCalloutAccessoryView = LandmarkCalloutView(annotation: annotation, selectShowDirections: { [weak self]
        
        let landmarkPopOverView = LandmarkCalloutView(annotation: annotation, selectShowDirections: { [weak self]
            place in
            
            let start = MKMapItem.forCurrentLocation()
            let destination = MKMapItem(placemark: MKPlacemark(coordinate: place.coordinate))
            
            self?.calculateRoute(start: start, destination: destination) {route in
                if let route = route {
                    
//                    view.detailCalloutAccessoryView = nil
                    
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
    
  ////
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
//        guard let mapPlace = annotation.title as? LandmarkAnnotation else {return nil}

        guard let mapPlace = annotation.title else {return nil}
        
//        print("mapPlace \(String(describing: mapPlace))")

//        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "customMapAnnotation") as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "customMapAnnotation")
        
        // add MKPointAnnotation to allow for subtitle
//        let pointAnnotation = MKPointAnnotation()
//        pointAnnotation.coordinate = annotation.coordinate
//        pointAnnotation.title = "title"
//        pointAnnotation.subtitle = "subTitle"
//        mapView.addAnnotation(pointAnnotation)
        
        
        
        
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: (mapPlace!)) else {
            return nil
            }

        

        
 


        annotationView.isEnabled = true
        annotationView.canShowCallout = true
//        let rightButton = UIButton(type: .detailDisclosure)
        let rightButton = UIButton(type: .contactAdd)

        annotationView.rightCalloutAccessoryView = rightButton
        
        
        return annotationView
    }
//MARK: - CALLOUT FUNCTION
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
       
        guard let name = view.annotation else {return}
//        let name = view.annotation
        print("Callout \(String(describing: name.title)) tapped")
        
        
//        let landmarkCalloutView = LandmarkCalloutView(annotation: name, selectShowDirections: <#T##(LandmarkAnnotation) -> Void#>)
        
        
        let currentPlaceCoordinate = (view.annotation?.coordinate)!
        
        let start = MKMapItem.forCurrentLocation()
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: currentPlaceCoordinate))
        
        self.calculateRoute(start: start, destination: destination) {route in
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
        
        
        
    }
//MARK: - End Callout function
    
    func calculateRoute(start: MKMapItem, destination: MKMapItem, completion: @escaping (MKRoute?) -> Void) {
        let directionsRequest = MKDirections.Request()
        directionsRequest.transportType = .automobile
        directionsRequest.source = start
        directionsRequest.destination = destination
        
        print(" calculating route")
        
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
