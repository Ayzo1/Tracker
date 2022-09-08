import Foundation

final class MainViewModel: MainViewModelProtocol {
	
	var recieveData: ((ViewData) -> Void)?
	
	// MARK: - Private properties
	
	private var locationService: LocationServiceProtocol
	private var trip: Trip?
	private var timer: Timer?
	private var currentState: TrackingState = .notTracking
	
	// MARK: - init
	
	init(locationService: LocationServiceProtocol) {
		self.locationService = locationService
	}
	
	// MARK: - MainViewModelProtocol
	
	func startTracking() {
		switch currentState {
		case .notTracking:
			locationService.startLocating()
			currentState = .tracking
			self.trip = Trip(startDate: Date(), distance: 0, time: 0, points: [(Double, Double)]())
			update()
			self.timer = Timer.scheduledTimer(
				timeInterval: 1,
				target: self,
				selector: #selector(updateTimer),
				userInfo: nil,
				repeats: true)
			recieveData?(ViewData.started)
			currentState = .tracking
			break
		case .paused:
			locationService.startLocating()
			self.timer = Timer.scheduledTimer(
				timeInterval: 1,
				target: self,
				selector: #selector(updateTimer),
				userInfo: nil,
				repeats: true)
			recieveData?(ViewData.resumed)
			currentState = .tracking
			break
		case .tracking:
			locationService.stopLocating()
			timer?.invalidate()
			recieveData?(ViewData.paused)
			currentState = .paused
			break
		}
	}
	
	func stopTracking() {
		locationService.stopLocating()
	}
	
	// MARK: - Private methods
	
	private func update() {
		locationService.recieveLocation = { [weak self] latitude, longitude, distance, speed in
			self?.trip?.distance += distance
			self?.trip?.points?.append((latitude, longitude))
            let viewData = ViewData.location(ViewData.Location(latitude: latitude, longitude: longitude, distance: self?.trip?.distance ?? 0, speed: speed))
			self?.recieveData?(viewData)
		}
	}
	
	// MARK: - objc methods
	
	@objc private func updateTimer() {
        let time = Date().timeIntervalSince(trip?.startDate ?? Date())
        recieveData?(ViewData.time(time))
	}
}
