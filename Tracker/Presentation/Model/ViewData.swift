//
//  Model.swift
//  Tracker
//
//  Created by ayaz on 07.09.2022.
//

import Foundation

enum ViewData {
    case time(TimeInterval)
    case location(Location)
    case error(Error)
    
    struct Location {
        let latitude: Double
        let longitude: Double
        let distance: Double
        let speed: Double
    }
}
