//
//  HoursPresenter.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 18.07.2021.
//

import Foundation
import UIKit

protocol HoursPresenterDelegateProtocol: AnyObject {
    func showLocalHoursWeather(result: FiveDaysWeatherModel)
    
    func showAlert(alert: UIAlertController)
}

typealias HoursPresenterDelegate = HoursPresenterDelegateProtocol & UIViewController

class HoursPresenter {
    
    weak var delegate: HoursPresenterDelegate?
    
    // вынести в инициализацию
    private let networkManager = NetworkManager()
    
    public func loadHoursWeather(lat: String, lon: String) {
        networkManager.getFiveDaysWeather(weatherType: .local(latitude: lat, longitude: lon), completion: {
            [weak self] result in
            switch result {
            case .success(let res):
                self?.delegate?.showLocalHoursWeather(result: res)
            case .failure(let err):
                print(err)
            }
        })
    }
    
    public func setViewDelegate(delegate: HoursPresenterDelegate) {
        self.delegate = delegate
    }
    
    public func onNavBarButtonClicked() {
        
        let alert = UIAlertController(title: "City", message: "Enter city name", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        let ok = UIAlertAction(title: "Ok", style: .default) {
            (action) -> Void in
            if let textField = alert.textFields?.first {
                if let typedCity = textField.text, !typedCity.isEmpty {
                    self.networkManager.getFiveDaysWeather(weatherType: .city(city: typedCity), completion: {
                        [weak self] result in
                        switch result {
                        case .success(let res):
                            self?.delegate?.showLocalHoursWeather(result: res)
                        case .failure(let err):
                            // отображать алерт о неудаче
                            print(err)
                        }
                    })
                }
            }
        }
        alert.addAction(ok)
        alert.addTextField {
            textField -> Void in
            textField.placeholder = "City name"
        }
        
        self.delegate?.showAlert(alert: alert)
    }
    
}
