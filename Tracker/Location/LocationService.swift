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
        // locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        // locationManager.distanceFilter = 1
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1
	}
	
	func startLocating() {
		locationManager.startUpdatingLocation()
	}
	
	func stopLocating() {
		locationManager.stopUpdatingLocation()
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
        recieveLocation?(last.coordinate.latitude, last.coordinate.longitude, distance, last.speed)
		previousLocation = locations.last
	}
}
