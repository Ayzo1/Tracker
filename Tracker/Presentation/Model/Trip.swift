import Foundation

struct Trip {
	
	var startDates: [Date]
	var endDates: [Date]
	var distance: Double
	var time: TimeInterval
	var points: [(Double, Double)]?
}
