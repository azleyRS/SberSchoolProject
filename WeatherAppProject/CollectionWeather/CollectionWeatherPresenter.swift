//
//  CollectionWeatherPresenter.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 26.07.2021.
//

import Foundation
import CoreData

protocol CollectionWeatherPresenterDelegateProtocol: AnyObject {
    
    func loadWeather()
    
    func deleteItems()
}

class CollectionWeatherPresenter {
    
    weak var delegate: CollectionWeatherPresenterDelegateProtocol?
    
    private let persistentContainer: NSPersistentContainer
    var collectionDataSource = [HoursCellModel]()

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    public func setViewDelegate(delegate: CollectionWeatherPresenterDelegateProtocol) {
        self.delegate = delegate
    }
    
    public func loadWeatherList() {
        do {
            let weatherEntityList: [CoreDataWeatherEntity] = try persistentContainer.viewContext.fetch(CoreDataWeatherEntity.fetchRequest())
            collectionDataSource = weatherEntityList.map{
                HoursCellModel(
                    city: $0.city,
                    time: $0.time,
                    temperature: $0.temperature,
                    description: $0.weatherDescription,
                    humidity: $0.humidity,
                    wind: $0.wind,
                    imageId: $0.icon
                )
            }
        } catch let error as NSError{
            // мб добавить алерт или надпись, что ничего не загрузилось
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        delegate?.loadWeather()
    }
    
}
