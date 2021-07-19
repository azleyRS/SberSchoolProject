//
//  AppDelegate.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 11.07.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let tabBarController = UITabBarController()
        let currentWeatherViewController = CurrentWeatherViewController()
        currentWeatherViewController.tabBarItem = UITabBarItem(title: "Current Weather Data", image: UIImage(systemName: "location"), tag: 1)
        let hoursWeatherViewController = HoursWeatherViewController()
        hoursWeatherViewController.tabBarItem = UITabBarItem(title: "5 Day / 3 Hour Forecast", image: UIImage(systemName: "timer"), tag: 2)
        tabBarController.viewControllers = [currentWeatherViewController, hoursWeatherViewController]
        let navigationController = UINavigationController(rootViewController: tabBarController)
        
        // Прозрачный статус бар
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        navigationController.view.backgroundColor = .clear
        
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }


}

