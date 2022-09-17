//
//  LandmarkCalloutView.swift
//  POIRouter
//
//  Created by Joseph Jung on 9/12/22.
//

import Foundation
import UIKit
import MapKit

class LandmarkCalloutView: UIView {
    
    private var annotation: LandmarkAnnotation
    private var selectShowDirections: (LandmarkAnnotation) -> Void
    

//    lazy var directionsButton: NSButton = {
//
//        let directionsButton = NSButton(frame: NSRect(x: 0, y: 0, width: 100, height: 100))
//        directionsButton.title = "Get Directions"
//        directionsButton.wantsLayer = true
//        directionsButton.isBordered = false
//        directionsButton.target = self
//        directionsButton.action = #selector(handleShowDirections)
//        return directionsButton
//    }()
   
    
    lazy var phoneTextField: UITextField = {
        
        let phoneTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
        
        if let phone = annotation.phone {
            phoneTextField.text = "Phone \n \(phone)"
        } else {
            phoneTextField.text = ""
        }
        
        phoneTextField.allowsEditingTextAttributes = false
        //        phoneTextField.isBezeled = false
        return phoneTextField
    }()
    
    
    lazy var addrssTextField: UITextField = {
        let addressTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
        addressTextField.text = annotation.address
        addressTextField.allowsEditingTextAttributes = false
//        addressTextField.isBezeled = false
        return addressTextField
    }()
    
    init(annotation: LandmarkAnnotation, frame: CGRect = CGRect(x:0, y:0, width: 400, height: 400), selectShowDirections: @escaping (LandmarkAnnotation) -> Void){
        self.annotation = annotation
        self.selectShowDirections = selectShowDirections
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Implemented...")
    }
    
    private func configure() {
        
        let stackView = UIStackView(frame: frame)
        
//        stackView.alignment = .left
        stackView.alignment = .leading

        stackView.axis = .vertical
        
//        stackView.edgeInsets = .init(top: 0, left: 20, bottom: 0, right: 20)
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
//        stackView.isLayoutMarginsRelativeArrangement = true
        
        let options = MKMapSnapshotter.Options()
        options.size = CGSize(width: frame.width, height: frame.height/2)
        options.mapType = .standard
        
        options.camera = MKMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 250, pitch: 65, heading: 0)
        
        let snapshotter = MKMapSnapshotter(options: options)
        
        snapshotter.start { snapshot, error in
            guard let snapshot = snapshot, error == nil else {return}
            
            DispatchQueue.main.async {
                let imageView = UIImageView(frame: CGRect(x:0, y: 0, width: 100, height: 100))
                imageView.image = snapshot.image
//                stackView.insertView(imageView, at: 0, in: .top)
//                stackView.insertSubview(imageView, at: 0)
            }
            
            
        }
        
//        stackView.addArrangedSubview(directionsButton)
        stackView.addSubview(phoneTextField)
        stackView.addSubview(addrssTextField)

        let scrollView = UIScrollView(frame: frame)
//        scrollView.hasVerticalScroller = true
        scrollView.isScrollEnabled = true

//        scrollView.documentView = stackView
        scrollView.addSubview(stackView)

        self.addSubview(scrollView)
    }
}
