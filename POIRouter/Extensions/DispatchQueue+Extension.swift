//
//  DispatchQueue+Extension.swift
//  POIRouter
//
//  Created by Joseph Jung on 9/11/22.
//

import Foundation


extension DispatchQueue {
    static func log(action: String) {
        print("""
                \(action):
                \(String(validatingUTF8: __dispatch_queue_get_label(nil))!)
                \(Thread.current)
                
                """)
    }
}
