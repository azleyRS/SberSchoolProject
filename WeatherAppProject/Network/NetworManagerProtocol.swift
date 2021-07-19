//
//  NetworManagerProtocol.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 18.07.2021.
//

import Foundation

enum WeatherType {
    case local(latitude: String, longitude: String)
    case city(city: String)
}

enum ErrorMessage: String, Error {
    case invalidData = "Invalid Data"
    case invalidResponse = "Invalid Response"
}

protocol NetworkManagerProtocol {
    
    func getCurrentWeather(weatherType: WeatherType, completion: @escaping (Result<CurrentWeather, ErrorMessage>) -> Void)
    
    func getFiveDaysWeather(weatherType: WeatherType, completion: @escaping (Result<FiveDaysWeatherModel, ErrorMessage>) -> Void)
//    
//    func getThirtyDaysWeather(weatherType: WeatherType, completion: @escaping (Result<Welcome, ErrorMessage>) -> Void)
}
