//
//  HoursPresenter.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 18.07.2021.
//

import Foundation
import CoreData

protocol HoursPresenterDelegateProtocol: AnyObject {
        
    func showLocalHoursWeather()
    
    func setTitle(title: String)
    
}

class HoursPresenter {
    
    private(set) var weatherData = [HoursCellModel]()
    private(set) var weatherSectionsData = [[HoursCellModel]]()
    let sectionTitleCount = 4
    
    weak var delegate: HoursPresenterDelegateProtocol?
    
    private let networkManager: NetworkManagerProtocol
    private let persistentContainer: NSPersistentContainer
    
    init(networkManager: NetworkManagerProtocol, persistentContainer: NSPersistentContainer) {
        self.networkManager = networkManager
        self.persistentContainer = persistentContainer
    }
    
    public func loadHoursWeather(lat: String, lon: String) {
        networkManager.getFiveDaysWeather(weatherType: .local(latitude: lat, longitude: lon), completion: handleNetworkResult)
    }
    
    public func setViewDelegate(delegate: HoursPresenterDelegateProtocol) {
        self.delegate = delegate
    }
    
    public func loadHoursCityWeather(city: String) {
        self.networkManager.getFiveDaysWeather(weatherType: .city(city: city), completion: self.handleNetworkResult)
    }
    
    private lazy var handleNetworkResult: ((Result<FiveDaysWeatherModel, ErrorMessage>) -> Void) = {
        [weak self] result in
        switch result {
        case .success(let res):
            var resultList = [HoursCellModel]()

            let cityName = res.city.name
            let measurementFormatter = MeasurementFormatter()
            measurementFormatter.numberFormatter.maximumFractionDigits = 0
            measurementFormatter.unitOptions = .providedUnit
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .short

            func getTemp(_ temp : Double) -> String {
                let result = Measurement(value: temp, unit: UnitTemperature.kelvin).converted(to: UnitTemperature.celsius)
                return measurementFormatter.string(from: result)
            }

            func getTime(_ time: Int) -> String {
                return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(time)))
            }

            res.list.forEach { item in
                resultList.append(
                    HoursCellModel(
                        city: cityName,
                        time: getTime(item.dt),
                        temperature: getTemp(item.main.temp),
                        description: item.weather.first?.weatherDescription ?? "",
                        humidity: String(item.main.humidity),
                        wind: String(item.wind.speed),
                        imageId: item.weather.first?.icon))
            }

            self?.weatherData = resultList
            self?.delegate?.showLocalHoursWeather()
            self?.delegate?.setTitle(title: resultList.first?.city ?? "Choose city")
        case .failure(let err):
            print(err)
        }
    }
    
    func saveWeather() {
        // here saving data
        weatherData.forEach {
            let weatherEntity = CoreDataWeatherEntity(entity: CoreDataWeatherEntity.entity(), insertInto: persistentContainer.viewContext)
            weatherEntity.city = $0.city
            weatherEntity.time = $0.time
            weatherEntity.temperature = $0.temperature
            weatherEntity.icon = $0.imageId
            weatherEntity.humidity = $0.humidity
            weatherEntity.weatherDescription = $0.description
            weatherEntity.wind = $0.wind
            saveContext()
            print(weatherEntity)
        }
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
}
