//
//  CoreDataWeatherEntity+CoreDataProperties.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 25.07.2021.
//
//

import Foundation
import CoreData


extension CoreDataWeatherEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataWeatherEntity> {
        return NSFetchRequest<CoreDataWeatherEntity>(entityName: "CoreDataWeatherEntity")
    }

    @NSManaged public var time: String
    @NSManaged public var city: String
    @NSManaged public var temperature: String
    @NSManaged public var icon: String?
    @NSManaged public var weatherDescription: String
    @NSManaged public var humidity: String
    @NSManaged public var wind: String

}

extension CoreDataWeatherEntity : Identifiable {

}
