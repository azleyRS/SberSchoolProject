//
//  FiveDaysWeatherModels.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 18.07.2021.
//

import Foundation

class HoursCellModel {
    let city : String
    @objc let time : String
    let temperature : String
    let description : String
    let humidity : String
    let wind : String
    let imageId : String?
    
    init(city: String,
         time: String,
         temperature: String,
         description: String,
         humidity: String,
         wind: String,
         imageId: String?) {
        self.city = city
        self.time = time
        self.temperature = temperature
        self.description = description
        self.humidity = humidity
        self.wind = wind
        self.imageId = imageId
    }
}

// MARK: - Welcome
struct FiveDaysWeatherModel: Codable {
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: City
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: FiveDaysCoord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - FiveDaysCoord
struct FiveDaysCoord: Codable {
    let lat, lon: Double
}

// MARK: - List
struct List: Codable {
    let dt: Int
    let main: MainClass
    let weather: [FiveDaysWeather]
    let clouds: FiveDaysClouds
    let wind: FiveDaysWind
    let visibility: Int
    let pop: Double
    let sys: FiveDaysSys
    let dtTxt: String
    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
        case rain
    }
}

// MARK: - FiveDaysClouds
struct FiveDaysClouds: Codable {
    let all: Int
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - FiveDaysSys
struct FiveDaysSys: Codable {
    let pod: Pod
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - FiveDaysWeather
struct FiveDaysWeather: Codable {
    let id: Int
    let main: String
    let weatherDescription: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - FiveDaysWind
struct FiveDaysWind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}

