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
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let networkManager = NetworkManager()

        let tabBarController = UITabBarController()
        let currentWeatherViewController = CurrentWeatherViewController(presenter: CurrentWeatherPresenter(networkManager: networkManager))
        currentWeatherViewController.tabBarItem = UITabBarItem(title: "Current Weather Data", image: UIImage(systemName: "location"), tag: 1)
        let hoursWeatherViewController = HoursWeatherViewController(presenter: HoursPresenter(networkManager: networkManager))
        hoursWeatherViewController.tabBarItem = UITabBarItem(title: "5 Day / 3 Hour Forecast", image: UIImage(systemName: "timer"), tag: 2)
        let collectionViewController = CollectionWeatherViewController()
        collectionViewController.tabBarItem = UITabBarItem(title: "Collection Weather Date", image: UIImage(systemName: "list.star"), tag: 3)

        tabBarController.viewControllers = [
            UINavigationController(rootViewController: currentWeatherViewController),
            UINavigationController(rootViewController: hoursWeatherViewController),
            UINavigationController(rootViewController: collectionViewController)
        ]
        
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }


}

