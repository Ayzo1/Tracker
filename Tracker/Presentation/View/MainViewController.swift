import UIKit
import MapKit

class MainViewController: UIViewController, MainViewProtocol {
	
	private var viewModel: MainViewModelProtocol

	init(viewModel: MainViewModelProtocol) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = .red
		viewModel.startTracking()
		update()
    }
	
	private func update() {
		viewModel.recieveData = { a, b in
			print(a)
		}
	}
}
