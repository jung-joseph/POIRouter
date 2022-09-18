//
//  PopOverViewController.swift
//  POIRouter
//
//  Created by Joseph Jung on 9/18/22.
//

import Foundation
import UIKit
import MapKit

class PopOverViewController: UIViewController {
    
    private var annotation: MKAnnotation
    
    init (annotation: MKAnnotation) {
        self.annotation = annotation as MKAnnotation
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = LandmarkCalloutView(annotation: self.annotation as! LandmarkAnnotation, selectShowDirections: {[weak self] landmark in
            
            let controller = PopOverViewController(annotation: self!.annotation)
            let positioningView = UIView(frame: CGRect(x: self!.view.frame.width/2.6, y:0, width:
                                                        self!.view.frame.width/2, height: 30.0))
            self?.view.addSubview(positioningView)
            
            // clear all overlays
//            self?.removeOverlay(self?.overlays)
            
            // add overlay on the map
//            self?.view.addSubview(self?.view)
//            self?.view.show(relativeTo: positioningView.frame, of: positioningView, preferredEdge: .minY)
        })
            
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented...")
    }
    
}
