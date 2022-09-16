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
			self.trip = Trip(startDates: [Date](), endDates: [Date](),distance: 0, time: 0, points: [(Double, Double)]())
			startLocating(state: ViewData.started)
			update()
			break
		case .paused:
			startLocating(state: ViewData.resumed)
			break
		case .tracking:
			stopLocating()
			break
		}
	}
	
	func stopTracking() {
		locationService.stopLocating()
	}
	
	// MARK: - Private methods
	
	private func startLocating(state: ViewData) {
		locationService.startLocating()
		startTimer()
		trip?.startDates.append(Date())
		currentState = .tracking
		recieveData?(state)
		currentState = .tracking
	}
	
	private func stopLocating() {
		locationService.stopLocating()
		trip?.endDates.append(Date())
		timer?.invalidate()
		let time = calculateTime()
		trip?.time += time
		recieveData?(ViewData.paused)
		currentState = .paused
	}
	
	private func startTimer() {
		self.timer = Timer.scheduledTimer(
			timeInterval: 1,
			target: self,
			selector: #selector(updateTimer),
			userInfo: nil,
			repeats: true)
	}
	
	private func update() {
		locationService.recieveLocation = { [weak self] latitude, longitude, distance, speed in
			self?.trip?.distance += distance
			self?.trip?.points?.append((latitude, longitude))
            let viewData = ViewData.location(ViewData.Location(latitude: latitude, longitude: longitude, distance: self?.trip?.distance ?? 0, speed: speed))
			self?.recieveData?(viewData)
		}
	}
	
	private func calculateTime() -> TimeInterval {
		guard let startDate = trip?.startDates.last else {
			return 0
		}
		let time = Date().timeIntervalSince(startDate)
		return time
	}
	
	// MARK: - objc methods
	
	@objc private func updateTimer() {
		let time = calculateTime()
		recieveData?(ViewData.time((trip?.time ?? 0) + time))
	}
}
