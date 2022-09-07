import Foundation

protocol LocationServiceProtocol: NSObject {
	
	func startLocating()
	func stopLocating()
	var recieveLocation: ((_ latitude: Double,
                           _ longitude: Double,
                           _ distance: Double,
                           _ speed: Double) -> ())? { get set }
}
