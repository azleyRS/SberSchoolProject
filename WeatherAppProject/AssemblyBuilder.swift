//
//  AssemblyBuilder.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 28.07.2021.
//

import Foundation
import UIKit
import CoreData

/// Протокол для создания необходимых зависимостей/экранов
protocol AssemblyBuilderProtocol {
    /// Создать рутовый UITabBarController с настроенными экранами
    func createRootTabBar() -> UITabBarController
}

final class AssemblyBuilder : AssemblyBuilderProtocol {
    
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    // todo мб сделать отдельный класс, который будет инкапсулировать логику получения данных из coreData самостоятельно
    private lazy var persistentContainer : NSPersistentContainer = {
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
    
    func createRootTabBar() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            createCurrentWeatherScreen(),
            createHoursWeatherScreen(),
            createCollectionWeatherScreen()
        ]
        return tabBarController
    }
    
    /// Создать экран с текущей погодой
    private func createCurrentWeatherScreen() -> UIViewController {
        let backgroundImageService: CurrentWeatherBackgroundImageServiceProtocol = CurrentWeatherBackgroundImageService()
        let presenter = CurrentWeatherPresenter(networkManager: networkManager, backgroundImageService: backgroundImageService)
        let currentWeatherViewController = CurrentWeatherViewController(presenter: presenter)
        currentWeatherViewController.tabBarItem = UITabBarItem(title: "Current Weather Data", image: UIImage(systemName: "location"), tag: 1)
        return UINavigationController(rootViewController: currentWeatherViewController)
    }
    
    /// Создать экран с прогнозом на 5 дней (каждые 3 часа подробно)
    private func createHoursWeatherScreen() -> UIViewController {
        let presenter = HoursPresenter(networkManager: networkManager, persistentContainer: persistentContainer)
        let hoursWeatherViewController = HoursWeatherViewController(presenter: presenter)
        hoursWeatherViewController.tabBarItem = UITabBarItem(title: "5 Days / 3 Hour Forecast", image: UIImage(systemName: "timer"), tag: 2)
        return UINavigationController(rootViewController: hoursWeatherViewController)
    }
    
    /// Создать экран с таблицей сохраненных прогнозов погоды
    private func createCollectionWeatherScreen() -> UIViewController {
        let presenter = CollectionWeatherPresenter(persistentContainer: persistentContainer)
        let collectionViewController = CollectionWeatherViewController(presenter: presenter)
        collectionViewController.tabBarItem = UITabBarItem(title: "Collection Weather Date", image: UIImage(systemName: "list.bullet"), tag: 3)
        return UINavigationController(rootViewController: collectionViewController)
    }
}
