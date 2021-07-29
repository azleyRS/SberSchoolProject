//
//  CoreDataService.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 28.07.2021.
//

import Foundation
import CoreData


/// Протокол для сохранения данных
protocol PersistentServiceProtocol {
    
    /// Сохранить список погоды
    /// - Parameter weatherList: список с прогнозом погоды
    func saveWeatherList(weatherList: [HoursCellModel])
}

/// Сервис сохранения данных используя CoreData
final class CoreDataPersistantService : PersistentServiceProtocol {
    
    private let persistentContainer: NSPersistentContainer
    private lazy var context = persistentContainer.viewContext
    
    
    /// Конструктор
    /// - Parameter persistentContainer: контейнер для инкапсуляции взаимодействия с CoreData
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func saveWeatherList(weatherList: [HoursCellModel]) {
        weatherList.forEach {
            let weatherEntity = CoreDataWeatherEntity(entity: CoreDataWeatherEntity.entity(), insertInto: persistentContainer.viewContext)
            weatherEntity.city = $0.city
            weatherEntity.time = $0.time
            weatherEntity.temperature = $0.temperature
            weatherEntity.icon = $0.imageId
            weatherEntity.humidity = $0.humidity
            weatherEntity.weatherDescription = $0.description
            weatherEntity.wind = $0.wind
            saveContext()
        }
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Some fatal error \(error)")
            }
        }
    }
    
    
}
