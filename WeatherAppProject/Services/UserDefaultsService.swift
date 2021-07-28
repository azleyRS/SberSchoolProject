//
//  UserDefaultsService.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 28.07.2021.
//

import Foundation


/// Протокол для определения фона экрана текущей погоды
protocol CurrentWeatherBackgroundImageServiceProtocol {
    
    /// маркер тогла
    ///  true если включен
    ///  false - иначе
    var isEnabled : Bool { get set }
    
    /// получить название изображения для фона
    func getCurrentWeatherBackground() -> String
}


/// Реализация протокола для определения фона экрана текущей погоды, использует UserDefaults под капотом
final class CurrentWeatherBackgroundImageService: CurrentWeatherBackgroundImageServiceProtocol {
    
    private enum UserDefaultsKeys: String {
        case switchEnabledKey
    }
    
    var isEnabled : Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultsKeys.switchEnabledKey.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKeys.switchEnabledKey.rawValue)
        }
    }
    
    func getCurrentWeatherBackground() -> String {
        return isEnabled ? "weatherBackground" : "weatherBackground2"
    }
}
