//
//  AppDelegate.swift
//  Tracker
//
//  Created by ayaz on 18.08.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		window = UIWindow(frame: UIScreen.main.bounds)
		// let temperatureViewController = TemperatureViewController()
		window?.rootViewController = MainViewController()
		window?.makeKeyAndVisible()
		
		return true
	}
}

