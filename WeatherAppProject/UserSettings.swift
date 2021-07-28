//
//  UserSettings.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 27.07.2021.
//

import Foundation


// подумать над подобным использованием
final class UserSettings {
    
    private enum SettingsKeys: String {
        case backgorundImageName
    }
    
    static var backgroundImageName: String {
        get {
            return UserDefaults.standard.string(forKey: SettingsKeys.backgorundImageName.rawValue) ?? "weatherBackground"
        }
        set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.backgorundImageName.rawValue
            defaults.set(newValue, forKey: key)
        }
    }
}
