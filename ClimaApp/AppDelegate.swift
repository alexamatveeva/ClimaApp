//
//  AppDelegate.swift
//  ClimaApp
//
//  Created by Alexandra on 31.08.2022.
//

import UIKit

let appColor = UIColor(named: "weatherColor")

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        window?.rootViewController = WeatherViewController()
        
        return true
    }


}

