//
//  CurrentWeatherPresenter.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 20.07.2021.
//

import Foundation
import UIKit


protocol CurrentWeatherPresenterDelegateProtocol: AnyObject {
    func showLocalWeather(result: CurrentWeather)
    
    func showAlert(alert: UIAlertController)
}

typealias CurrentPresenterDelegate = CurrentWeatherPresenterDelegateProtocol & UIViewController

class CurrentWeatherPresenter {
    weak var delegate : CurrentPresenterDelegate?
    
    // вынести в инициализацию
    private let networkManager = NetworkManager()
    
    public func setViewDelegate(delegate: CurrentPresenterDelegate) {
        self.delegate = delegate
    }
    
    public func loadLocalWeather(latitude: String, longitude: String) {
        networkManager.getCurrentWeather(weatherType: .local(latitude: latitude, longitude: longitude), completion: {
            [weak self] result in
            switch result {
            case .success(let res):
                self?.delegate?.showLocalWeather(result: res)
            case .failure(let err):
                // отображать алерт о неудаче
                print(err)
            }
        })
    }
    
    public func onNavBarButtonClicked() {
        
        let alert = UIAlertController(title: "City", message: "Enter city name", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        let ok = UIAlertAction(title: "Ok", style: .default) {
            (action) -> Void in
            if let textField = alert.textFields?.first {
                if let typedCity = textField.text, !typedCity.isEmpty {
                    self.networkManager.getCurrentWeather(weatherType: .city(city: typedCity), completion: {
                        [weak self] result in
                        switch result {
                        case .success(let res):
                            self?.delegate?.showLocalWeather(result: res)
                        case .failure(let err):
                            // отображать алерт о неудаче
                            if let delegate = self?.delegate,
                               let self = self {
                                delegate.showAlert(alert: self.createErrorAlert(error: err))
                            }
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
    
    private func createErrorAlert(error: ErrorMessage) -> UIAlertController {
        let errorAlert = UIAlertController(title: error.rawValue, message: "Try again later", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        return errorAlert
    }

}
