import UIKit
import MapKit

final class MainViewController: UIViewController, MainViewProtocol {
	
	// MARK: - Private properties
	
	private var viewModel: MainViewModelProtocol
	private var previousLocation: CLLocationCoordinate2D?
	
    private var speedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
	private var timeLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private var distanceLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private var mapView: MKMapView = {
		let map = MKMapView()
		map.translatesAutoresizingMaskIntoConstraints = false
		map.mapType = .standard
		map.isZoomEnabled = true
		map.showsUserLocation = true
		return map
	}()
	
	private var startButton: UIButton = {
		var button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(startButtonAction), for: .touchUpInside)
		button.setTitle("Start", for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.backgroundColor = .orange
		return button
	}()
	
	// MARK: - init

	init(viewModel: MainViewModelProtocol) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecicle
	
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateViews()
		update()
		view.layoutSubviews()
		mapView.layer.cornerRadius = mapView.frame.height / 2
		mapView.delegate = self
    }

	// MARK: - Private methods
	
	private func configurateViews() {
        view.backgroundColor = .systemYellow
		view.addSubview(timeLabel)
		setupTimeLabel()
		view.addSubview(distanceLabel)
		setupDistanceLabel()
		view.addSubview(mapView)
		setupMapView()
        view.addSubview(speedLabel)
        setupSpeedLabel()
		view.addSubview(startButton)
		setupStartButton()
	}
	
	private func update() {
		viewModel.recieveData = { [weak self] viewData in
            switch viewData {
            case .time(let time):
                self?.timeLabel.text = self?.createTimeString(time: time) ?? " "
                break
            case .location(let location):
				self?.updateLocation(location: location)
                break
            case .error(let error):
                print(error.localizedDescription)
                break
			case .started, .resumed:
				self?.startButton.setTitle("Pause", for: .normal)
				break
			case .paused:
				self?.startButton.setTitle("Resume", for: .normal)
				break
			}
		}
	}
	
	private func updateLocation(location: ViewData.Location) {
		distanceLabel.text = "\(Int(location.distance))m"
		let kph = converMerterPerSecondToKilometersPerHour(speedInMps: location.speed)
		speedLabel.text = "\(String(format: "%.1f", kph))kph"
		let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
		let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
		let region = MKCoordinateRegion(center: coordinate, span: span)
		mapView.setRegion(region, animated: true)
		
		drawRoutes(coordinate: coordinate)
	}
	
	private func drawRoutes(coordinate: CLLocationCoordinate2D) {
		guard let previous = previousLocation else {
			previousLocation = coordinate
			return
		}
		
		let firstItem = MKMapItem(placemark: MKPlacemark(coordinate: previous))
		let secondItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
		let request = MKDirections.Request()
		request.source = firstItem
		request.destination = secondItem
		request.transportType = .walking
		let directions = MKDirections(request: request)
		directions.calculate { [weak self] response, error in
			guard let response = response else {
				return
			}
			guard let route = response.routes.first else {
				return
			}
			self?.mapView.addOverlay(route.polyline, level: .aboveRoads)
		}
		previousLocation = coordinate
	}
	
	private func converMerterPerSecondToKilometersPerHour(speedInMps: Double) -> Double {
		return speedInMps * 3.6
	}
	
	private func createTimeString(time: TimeInterval) -> String {
		let hours = Int(time) / 3600
		let minutes = Int(time) / 60 % 60
		let seconds = Int(time) % 60
		
		var times: [String] = []
		if hours > 0 {
		  times.append("\(hours)h")
		}
		if minutes > 0 {
		  times.append("\(minutes)m")
		}
		times.append("\(seconds)s")
		
		return times.joined(separator: " ")
	}
	
	private func setupTimeLabel() {
		timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
	}
	
	private func setupDistanceLabel() {
		distanceLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20).isActive = true
		distanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
	}
    
    private func setupSpeedLabel() {
        speedLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 20).isActive = true
        speedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
	
	private func setupMapView() {
		mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
		mapView.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -20).isActive = true
		mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
		mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
	}
	
	private func setupStartButton() {
		startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
		startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		startButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
		startButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
		startButton.layer.cornerRadius = 100 / 2
	}
	
	// MARK: - objc methods
	
	@objc private func startButtonAction() {
		viewModel.startTracking()
	}
}

extension MainViewController: MKMapViewDelegate {
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		let renderer = MKPolylineRenderer(overlay: overlay)
		renderer.strokeColor = .red
		renderer.lineWidth = 4.0
		return renderer
	}
}
