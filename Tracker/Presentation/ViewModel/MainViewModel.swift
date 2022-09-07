import Foundation

final class MainViewModel: MainViewModelProtocol {
	
	private var locationService: LocationServiceProtocol
	private var distance: Double = 0
	private var trip: Trip?
	var recieveData: ((ViewData) -> Void)?
	var timer: Timer?
	
	init(locationService: LocationServiceProtocol) {
		self.locationService = locationService
	}
	
	func startTracking() {
		locationService.startLocating()
		self.trip = Trip(startDate: Date(), distance: 0, time: 0, points: [(Double, Double)]())
		update()
		self.timer = Timer.scheduledTimer(
			timeInterval: 1,
			target: self,
			selector: #selector(updateTimer),
			userInfo: nil,
			repeats: true)
	}
	
	func stopTracking() {
		locationService.stopLocating()
	}
	
	private func update() {
		locationService.recieveLocation = { [weak self] latitude, longitude, distance, speed in
			self?.trip?.distance += distance
			self?.trip?.points?.append((latitude, longitude))
			//let time = Date().timeIntervalSince(self?.trip?.startDate ?? Date())
            let viewData = ViewData.location(ViewData.Location(latitude: latitude, longitude: longitude, distance: distance, speed: speed))
			self?.recieveData?(viewData)
		}
	}
	
	@objc private func updateTimer() {
        let time = Date().timeIntervalSince(trip?.startDate ?? Date())
        recieveData?(ViewData.time(time))
	}
}
