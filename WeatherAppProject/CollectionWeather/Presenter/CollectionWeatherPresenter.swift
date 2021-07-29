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
    
    func deleteItemsFromView(indexPaths: [IndexPath])
}

class CollectionWeatherPresenter {
    
    weak var delegate: CollectionWeatherPresenterDelegateProtocol?
    
    var fetchedRC: NSFetchedResultsController<CoreDataWeatherEntity>?
    
    private let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    public func setViewDelegate(delegate: CollectionWeatherPresenterDelegateProtocol) {
        self.delegate = delegate
    }
    
    public func loadWeatherList() {
        do {
            let fetchRequest: NSFetchRequest<CoreDataWeatherEntity> = CoreDataWeatherEntity.fetchRequest()
            let city = NSSortDescriptor(key: #keyPath(CoreDataWeatherEntity.city), ascending: true)
            fetchRequest.sortDescriptors = [city]
            fetchedRC = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                        managedObjectContext: persistentContainer.viewContext,
                                                        sectionNameKeyPath: #keyPath(CoreDataWeatherEntity.city),
                                                        cacheName: nil)
            try fetchedRC?.performFetch()
        } catch let error as NSError{
            // мб добавить алерт или надпись, что ничего не загрузилось
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        delegate?.loadWeather()
    }
    
    public func deleteItems(indexPaths: [IndexPath]) {
        //let items = indexPaths.sorted().reversed() as [IndexPath]
        let items = indexPaths
        for item in items {
            if let weatherModel = fetchedRC?.object(at: item) {
                persistentContainer.viewContext.delete(weatherModel)
            }
        }
        saveContext()
        delegate?.deleteItemsFromView(indexPaths: items)
    }
    
    public func getNumbersInSection(section: Int) -> Int {
        do{
            try fetchedRC?.performFetch()
        } catch {
            print("fetchedRC?.performFetch()")
        }
        guard let sections = fetchedRC?.sections,
              let objs = sections[section].objects else {
            return 0
        }
        return objs.count
    }
    
    public func getNumberOfSectons() -> Int {
        return fetchedRC?.sections?.count ?? 0
    }
    
    public func getHeaderName(indexPath: IndexPath) -> String? {
        let model = fetchedRC?.sections?[indexPath.section].objects?.first as? CoreDataWeatherEntity
        return model?.city
    }
    
    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Some fatal error \(error)")
            }
        }
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
