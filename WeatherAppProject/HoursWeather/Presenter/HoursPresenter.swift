//
//  HoursPresenter.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 18.07.2021.
//

import Foundation
import CoreData

/// Протокол делегата презентера для экрана с прогнозом погоды на 5 дней / каждые 3 часа
protocol HoursPresenterDelegateProtocol: AnyObject {
        
    /// Отобразить список с прогнозом погоды на 5 дней / каждые три дня
    func showLocalHoursWeather()
    
    /// Отобразить заголовок экрана
    /// - Parameter title: текст заголовка
    func setTitle(title: String)
}

/// Презентер экрана с прогнозом погоды на 5 дней / каждые 3 часа
class HoursPresenter {
    
    private(set) var weatherData = [HoursCellModel]()
    
    private weak var delegate: HoursPresenterDelegateProtocol?
    
    private let networkManager: NetworkManagerProtocol
    private let persistentService: PersistentServiceProtocol
    
    
    /// Конструктор презентера
    /// - Parameters:
    ///   - networkManager: менеджер для сетевых запросов
    ///   - persistentService: сервис для сохранения данных
    init(networkManager: NetworkManagerProtocol, persistentService: PersistentServiceProtocol) {
        self.networkManager = networkManager
        self.persistentService = persistentService
    }
    
    
    /// Загрузить прогноз погоды по координатам
    /// - Parameters:
    ///   - lat: широта
    ///   - lon: долгота
    public func loadHoursWeather(lat: String, lon: String) {
        networkManager.getFiveDaysWeather(weatherType: .local(latitude: lat, longitude: lon), completion: handleNetworkResult)
    }
    
    
    /// Установить делегат презентера
    /// - Parameter delegate: делегат презентера
    public func setViewDelegate(delegate: HoursPresenterDelegateProtocol) {
        self.delegate = delegate
    }
    
    
    /// Загрузить прогноз погоды по названию города
    /// - Parameter city: название города
    public func loadHoursCityWeather(city: String) {
        self.networkManager.getFiveDaysWeather(weatherType: .city(city: city), completion: self.handleNetworkResult)
    }
    
    
    /// Сохранить текущий список с прогнозом погоды
    func saveWeather() {
        persistentService.saveWeatherList(weatherList: weatherData)
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
}
