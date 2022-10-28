//
//  UserSettings.swift
//  POIRouter
//
//  Created by Joseph Jung on 10/28/22.
//

import Foundation
import SwiftUI

class UserSettings: ObservableObject {
    
    @Published var isDarkMode: Bool = false
    @Published var distanceUnit: DistanceUnit = .miles
}
