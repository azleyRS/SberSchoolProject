//
//  CurrentWeatherPresenter.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 20.07.2021.
//

import Foundation


protocol CurrentWeatherPresenterDelegateProtocol: AnyObject {
    
    func showLocalWeather(result: CurrentWeather)
    
    func showAlert(title: String)
    
    func startActivityIndicator()
    
    func stopActivityIndicator()
}

class CurrentWeatherPresenter {
    
    weak var delegate : CurrentWeatherPresenterDelegateProtocol?
    
    internal let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
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
    
    private lazy var handleNetworkResult: ((Result<CurrentWeather, ErrorMessage>) -> Void) = {
        [weak self] result in
        switch result {
        case .success(let res):
            self?.delegate?.showLocalWeather(result: res)
        case .failure(let err):
            if let delegate = self?.delegate,
               let self = self {
                delegate.showAlert(title: err.rawValue)
            }
        }
        self?.delegate?.stopActivityIndicator()
    }

}
