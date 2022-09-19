import CoreLocation
import Foundation

final class LocationService: NSObject, LocationServiceProtocol {
	
	var recieveLocation: ((Double, Double, Double, Double) -> ())?
	private let locationManager = CLLocationManager()
	private var previousLocation: CLLocation?

	override init() {
		super.init()
		locationManager.delegate = self
		locationManager.requestAlwaysAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
	}
	
	func startLocating() {
		locationManager.startUpdatingLocation()
	}
	
	func stopLocating() {
		locationManager.stopUpdatingLocation()
		previousLocation = nil
	}
	
	private func CalculateSpeed(location: CLLocation) -> CLLocationSpeed {
		guard let previous = previousLocation else {
			return 0
		}
		let time = location.timestamp.timeIntervalSince(previous.timestamp)
		if time <= 0 {
			return 0
		}
		let distance = location.distance(from: previous)
		return distance / time
	}
}

extension LocationService: CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager,
						 didUpdateLocations locations: [CLLocation]) {
		guard let last = locations.last else {
			return
		}
		var distance: Double = 0
		if previousLocation != nil {
			distance = last.distance(from: previousLocation!)
		}
		var speed = last.speed
		if speed < 0 {
			speed = self.CalculateSpeed(location: last)
		}
        recieveLocation?(last.coordinate.latitude, last.coordinate.longitude, distance, speed)
		previousLocation = locations.last
	}
}
