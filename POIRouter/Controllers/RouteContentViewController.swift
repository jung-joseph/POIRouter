//
//  RouteContentViewController.swift
//  POIRouter
//
//  Created by Joseph Jung on 9/14/22.
//

import Foundation
import UIKit
import MapKit

class RouteContentViewController: UIViewController {
    
    private var route: MKRoute
    
    init( route: MKRoute) {
        self.route = route
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = RouteCalloutView(route: route)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented...")
    }
}
