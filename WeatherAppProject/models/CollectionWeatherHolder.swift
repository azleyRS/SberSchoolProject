//
//  CollectionWeatherHolder.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 23.07.2021.
//

import Foundation

class CollectionModelHolder {
    var savedWeatherList = [CollectionModel]()
}

struct CollectionModel {
    let time: String
    let city: String
    let temperature: String
}
