//
//  LocationServiceProtocol.swift
//  Tracker
//
//  Created by ayaz on 19.08.2022.
//

import Foundation

protocol LocationServiceProtocol: NSObject {
	
	func startLocating()
	func stopLocating()
	var recieveLocation: ((_ latitude: Double, _ longitude: Double, _ distance: Double) -> ())? { get set }
}
