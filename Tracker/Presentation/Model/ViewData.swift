import Foundation

enum ViewData {
    case time(TimeInterval)
    case location(Location)
	case started
	case paused
	case resumed
    case error(Error)
    
    struct Location {
        let latitude: Double
        let longitude: Double
        let distance: Double
        let speed: Double
    }
}
