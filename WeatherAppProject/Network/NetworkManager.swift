//
//  NetworkManager.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 18.07.2021.
//

import Foundation

class NetworkManager: NetworkManagerProtocol {
    
    let baseUrl = "https://api.openweathermap.org/data/2.5"
    
    func getCurrentWeather(weatherType: WeatherType, completion: @escaping (Result<CurrentWeather, ErrorMessage>) -> Void) {
        print("NetworkManager getCurrentWeather")

        var resultQueryItems : [URLQueryItem]
        
        switch weatherType {
        case .city(let cityName):
            let queryItemCity = URLQueryItem(name: "q", value: cityName)
            resultQueryItems = [queryItemCity]
        case let .local(lat, lon):
            let queryItemLatitude = URLQueryItem(name: "lat", value: String(lat))
            let queryItemLongitude = URLQueryItem(name: "lon", value: String(lon))
            resultQueryItems = [queryItemLatitude, queryItemLongitude]
        }
        let queryItemKey = URLQueryItem(name: "appid", value: "b3bdb37b1f087eb7b3b1a674bdcbb859")
        resultQueryItems.append(queryItemKey)
        guard var url = URL(string: baseUrl) else {return}
        url.appendPathComponent("weather")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = resultQueryItems
        
        guard let resultUrl = components?.url else { return }
        
        let task = URLSession.shared.dataTask(with: resultUrl) {
            (data, response, error) in
            
            if let _ = error {
                completion(.failure(.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let resultData = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(CurrentWeather.self, from: resultData)
                completion(.success(result))
            } catch {
                completion(.failure(.invalidData))
            }
            
        }
        task.resume()
    }
    
    func getFiveDaysWeather(weatherType: WeatherType, completion: @escaping (Result<FiveDaysWeatherModel, ErrorMessage>) -> Void) {
        print("NetworkManager getFiveDaysWeather")

        var resultQueryItems : [URLQueryItem]
        
        switch weatherType {
        case .city(let cityName):
            let queryItemCity = URLQueryItem(name: "q", value: cityName)
            resultQueryItems = [queryItemCity]
        case let .local(lat, lon):
            let queryItemLatitude = URLQueryItem(name: "lat", value: String(lat))
            let queryItemLongitude = URLQueryItem(name: "lon", value: String(lon))
            resultQueryItems = [queryItemLatitude, queryItemLongitude]
        }
        let queryItemKey = URLQueryItem(name: "appid", value: "b3bdb37b1f087eb7b3b1a674bdcbb859")
        resultQueryItems.append(queryItemKey)
        guard var url = URL(string: baseUrl) else {return}
        url.appendPathComponent("forecast")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = resultQueryItems
        
        guard let resultUrl = components?.url else { return }
        
        let task = URLSession.shared.dataTask(with: resultUrl) {
            (data, response, error) in
            
            
            
            //api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={API key}
            //api.openweathermap.org/data/2.5/forecast?lat=37.785834&lon=-122.406417&appid=b3bdb37b1f087eb7b3b1a674bdcbb859
            print("???????????")
            print(resultUrl)
            print(data)
            print(response)
            print(error)
            
            if let _ = error {
                completion(.failure(.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let resultData = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(FiveDaysWeatherModel.self, from: resultData)
                completion(.success(result))
            } catch {
                print(error)
                completion(.failure(.invalidData))
            }
            
        }
        task.resume()

    }
//    
//    func getThirtyDaysWeather(weatherType: WeatherType, completion: @escaping (Result<Welcome, ErrorMessage>) -> Void) {
//        print("getThirtyDaysWeather")
//    }
    
    
}
