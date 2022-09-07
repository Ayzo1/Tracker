import UIKit
import MapKit

final class MainViewController: UIViewController, MainViewProtocol {
	
	// MARK: - Private properties
	
	private var viewModel: MainViewModelProtocol
	
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
        // map.layer.cornerRadius = map.frame.height / 2
		return map
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
		viewModel.startTracking()
		update()
    }
    
    override func viewDidLayoutSubviews() {
        mapView.layer.cornerRadius = mapView.frame.height / 2
        print("aaa")
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
	}
	
	private func update() {
		viewModel.recieveData = { [weak self] viewData in
            
            switch viewData {
            case .time(let time):
                self?.timeLabel.text = self?.createTimeString(time: time) ?? " "
                break
            case .location(let location):
                self?.distanceLabel.text = "\(Int(location.distance))m"
                self?.speedLabel.text = "\(Int(location.speed))"
                let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self?.mapView.setRegion(region, animated: true)
                break
            case .error(let error):
                print(error.localizedDescription)
                break
            }
		}
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
		mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
		mapView.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -20).isActive = true
		mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
		mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
	}
}
