//
//  CurrentWeatherPresenter.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 20.07.2021.
//

import Foundation



/// Протокол делегата презентера для экрана с текущей погодой
protocol CurrentWeatherPresenterDelegateProtocol: AnyObject {
    
    /// Отобразить текущую погоду
    /// - Parameter presentationModel: модель с информацией о текущей погоде
    func showLocalWeather(presentationModel: CurrentWeatherPresentationModel)
    
    /// Отобразить иконку соответствующую текущей погоде
    /// - Parameter id: id иконки
    func showWeatherIcon(url: URL)
    
    /// Отобразить алерт
    /// - Parameter title: текст заголовка алерта
    func showAlert(title: String)
    
    /// Запустить отображение индикатора загрузки
    func startActivityIndicator()

    /// Остановить отобржание индикатора загрузки
    func stopActivityIndicator()
    
    /// Установить актуальный фон экрана
    /// - Parameter name: наименование изображения для фона
    func changeBackgroundImage(name: String)
    
    /// Установить переключатель в актуальную позицию
    /// - Parameter isEnabled: маркер положения тогда true - включен, false - отключен
    func setSwitch(isEnabled: Bool)
}

class CurrentWeatherPresenter {
    
    private weak var delegate : CurrentWeatherPresenterDelegateProtocol?
    
    private let networkManager: NetworkManagerProtocol
    private var backgroundImageService : CurrentWeatherBackgroundImageServiceProtocol
    
    init(networkManager: NetworkManagerProtocol, backgroundImageService: CurrentWeatherBackgroundImageServiceProtocol) {
        self.networkManager = networkManager
        self.backgroundImageService = backgroundImageService
    }
    
    public func setViewDelegate(delegate: CurrentWeatherPresenterDelegateProtocol) {
        self.delegate = delegate
    }
    
    public func loadLocalWeather(latitude: String, longitude: String) {
        self.delegate?.startActivityIndicator()
        networkManager.getCurrentWeather(weatherType: .local(latitude: latitude, longitude: longitude),completion:self.handleNetworkResult)
    }
    
    public func getCurrentWeather(city: String) {
        self.delegate?.startActivityIndicator()
        networkManager.getCurrentWeather(weatherType: .city(city: city),completion:self.handleNetworkResult)
    }
    
    public func handleBackgroundImage() {
        let imageName = backgroundImageService.getCurrentWeatherBackground()
        self.delegate?.changeBackgroundImage(name: imageName)
    }
    
    public func handleTogglePosition() {
        let isEnabled = backgroundImageService.isEnabled
        self.delegate?.setSwitch(isEnabled: isEnabled)
    }
    
    public func switchToggle(isEnabled: Bool) {
        backgroundImageService.isEnabled = isEnabled
        handleBackgroundImage()
    }
    
    private lazy var handleNetworkResult: ((Result<CurrentWeather, ErrorMessage>) -> Void) = {
        [weak self] result in
        switch result {
        case .success(let res):
            
            let measurementFormatter = MeasurementFormatter()
            measurementFormatter.numberFormatter.maximumFractionDigits = 0
            measurementFormatter.unitOptions = .providedUnit
            let convertedTemperature = Measurement(value: res.main.temp, unit: UnitTemperature.kelvin).converted(to: UnitTemperature.celsius)
            let temperature = String(measurementFormatter.string(from: convertedTemperature))

            let currentTime = Date(timeIntervalSince1970: TimeInterval(res.dt))
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .medium
            dateFormatter.dateStyle = .long
            let date = dateFormatter.string(from: currentTime)
            
            let presentationModel = CurrentWeatherPresentationModel(city: res.name,
                                                                    temperature: temperature,
                                                                    date: date)
            
            self?.delegate?.showLocalWeather(presentationModel: presentationModel)
            if let id = res.weather.first?.icon {
                if let iconUrl = URL(string: "https://openweathermap.org/img/wn")?
                    .appendingPathComponent("\(id)@2x")
                    .appendingPathExtension("png") {
                    self?.delegate?.showWeatherIcon(url: iconUrl)
                }
            }
        case .failure(let err):
            if let delegate = self?.delegate,
               let self = self {
                delegate.showAlert(title: err.rawValue)
            }
        }
        self?.delegate?.stopActivityIndicator()
    }

}
