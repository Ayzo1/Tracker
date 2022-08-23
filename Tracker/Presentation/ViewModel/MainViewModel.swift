import Foundation

final class MainViewModel: MainViewModelProtocol {
	
	private var locationService: LocationServiceProtocol
	
	init(locationService: LocationServiceProtocol) {
		self.locationService = locationService
	}
	
	var recieveData: ((Date, Double) -> Void)?
	
	func startTracking() {
		locationService.startLocating()
		update()
	}
	
	func stopTracking() {
		locationService.stopLocating()
	}
	
	private func update() {
		locationService.recieveLocation = { [weak self] latitude, longitude, distance in
			self?.recieveData?(Date(), distance)
		}
	}
}
