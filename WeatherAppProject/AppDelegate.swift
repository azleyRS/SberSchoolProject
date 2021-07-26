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
    lazy var persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherApp")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            print(storeDescription)
            if let error = error as NSError? {
                fatalError("Some fatal error \(error)")
            }
        })
        return container
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let networkManager = NetworkManager()

        let tabBarController = UITabBarController()
        let currentWeatherViewController = CurrentWeatherViewController(presenter: CurrentWeatherPresenter(networkManager: networkManager))
        currentWeatherViewController.tabBarItem = UITabBarItem(title: "Current Weather Data", image: UIImage(systemName: "location"), tag: 1)
        let hoursWeatherViewController = HoursWeatherViewController(presenter: HoursPresenter(networkManager: networkManager, persistentContainer: persistentContainer))
        hoursWeatherViewController.tabBarItem = UITabBarItem(title: "5 Day / 3 Hour Forecast", image: UIImage(systemName: "timer"), tag: 2)
        let collectionViewController = CollectionWeatherViewController(presenter: CollectionWeatherPresenter(persistentContainer: persistentContainer))
        collectionViewController.tabBarItem = UITabBarItem(title: "Collection Weather Date", image: UIImage(systemName: "list.bullet"), tag: 3)

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

