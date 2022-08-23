import Foundation

final class MainViewModel: MainViewModelProtocol {
	
	private var locationService: LocationServiceProtocol?
	
	init() {
		
	}
	
	var recieveData: ((Date, Double) -> Void)?
	
	func startTracking() {
		locationService?.startLocating()
	}
	
	func stopTracking() {
		locationService?.stopLocating()
	}
	
	private func update() {
		locationService?.recieveLocation = { latitude, longitude, distance in
			
		}
	}
}
