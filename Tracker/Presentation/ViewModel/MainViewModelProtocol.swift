import Foundation

protocol MainViewModelProtocol {
	
	func startTracking()
	func stopTracking()
	var recieveData: ((_ time: TimeInterval, _ distance: Double, _ latitude: Double, _ longitude: Double) -> Void)? { get set }
}
