import Foundation

protocol MainViewModelProtocol {
	
	func startTracking()
	func stopTracking()
	var recieveData: ((ViewData) -> Void)? { get set }
}
