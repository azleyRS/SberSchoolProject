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
    
    var fetchedRC: NSFetchedResultsController<CoreDataWeatherEntity>?
    
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
            let fetchRequest: NSFetchRequest<CoreDataWeatherEntity> = CoreDataWeatherEntity.fetchRequest()
            fetchRequest.sortDescriptors = .init()
            fetchedRC = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                        managedObjectContext: persistentContainer.viewContext,
                                                        sectionNameKeyPath: nil,
                                                        cacheName: nil)
            try fetchedRC?.performFetch()
        } catch let error as NSError{
            // мб добавить алерт или надпись, что ничего не загрузилось
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        delegate?.loadWeather()
    }
    
    
    func getCellModel(indexPath: IndexPath) -> HoursCellModel {
        let coreDataModel = self.fetchedRC?.object(at: indexPath)
        return HoursCellModel(city: coreDataModel?.city ?? "city",
                              time: coreDataModel?.time ?? "time",
                              temperature: coreDataModel?.temperature ?? "temperature",
                              description: coreDataModel?.weatherDescription ?? "weatherDescription",
                              humidity: coreDataModel?.humidity ?? "humidity",
                              wind: coreDataModel?.wind ?? "wind",
                              imageId: coreDataModel?.icon)
    }
    
}
