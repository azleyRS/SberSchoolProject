//
//  AppDelegate.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 11.07.2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootViewController = AssemblyBuilder().createRootTabBar()
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        return true
    }


}

