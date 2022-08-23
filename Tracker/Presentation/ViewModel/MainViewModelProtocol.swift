import Foundation

protocol MainViewModelProtocol {
	
	func startTracking()
	func stopTracking()
	var recieveData: ((_ time: Date, _ distance: Double) -> Void)? { get set }
}
