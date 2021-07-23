//
//  HoursPresenter.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 18.07.2021.
//

import Foundation

protocol HoursPresenterDelegateProtocol: AnyObject {
        
    func showLocalHoursWeather()
    
}

class HoursPresenter {
    
    private(set) var weatherData = [HoursCellModel]()
    private(set) var weatherSectionsData = [[HoursCellModel]]()
    let sectionTitleCount = 4
    
    weak var delegate: HoursPresenterDelegateProtocol?
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
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
                    HoursCellModel(city: cityName, time: getTime(item.dt), temperature: getTemp(item.main.temp), description: item.weather.first!.weatherDescription, humidity: "Humidity is \(item.main.humidity)", wind: "Wind is \(item.wind.speed)", imageId: item.weather.first?.icon))
            }

            self?.weatherData = resultList
            self?.delegate?.showLocalHoursWeather()
        case .failure(let err):
            print(err)
        }
    }
}
