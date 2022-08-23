//
//  AppDelegate.swift
//  Tracker
//
//  Created by ayaz on 18.08.2022.
//

import UIKit
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	let container = Container()

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		registerDependecies()
		
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = container.resolve(MainViewController.self)!
		window?.makeKeyAndVisible()
		
		return true
	}
	
	private func registerDependecies() {
		container.register(LocationServiceProtocol.self) { _ in
			LocationService()
		}
		container.register(MainViewModelProtocol.self) { resolver in
			MainViewModel(locationService: resolver.resolve(LocationServiceProtocol.self)!)
		}
		container.register(MainViewController.self) { resolver in
			MainViewController(viewModel: resolver.resolve(MainViewModelProtocol.self)!)
		}
	}
}

