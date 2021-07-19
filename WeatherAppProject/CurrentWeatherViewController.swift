//
//  ViewController.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 11.07.2021.
//

import UIKit
import CoreLocation

class CurrentWeatherViewController: UIViewController {
        
    private let networkManager = NetworkManager()
    private let locationManager = CLLocationManager()
    
    private lazy var handleResult: ((Result<CurrentWeather, ErrorMessage>) -> Void) = { result in
        switch result {
        case .success(let welcome):
            if let icon = welcome.weather.first?.icon,
               let iconUrl = URL(string: "https://openweathermap.org/img/wn")?
                .appendingPathComponent("\(icon)@2x")
                .appendingPathExtension("png") {
                self.initIcon(iconUrl: iconUrl)
                self.initInfo(temp: welcome.main.temp, city: welcome.name)
            }
        case .failure(let err):
            print(err)
        }
    }
    
    private lazy var imageView: UIImageView = {
        let result = UIImageView()
        result.contentMode = .scaleAspectFit
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    private lazy var tempLabel: UILabel = {
        let result = UILabel()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.textColor = .black
        result.text = "Loading temperature..."
        return result
    }()
    
    private lazy var cityLabel: UILabel = {
        let result = UILabel()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.textColor = .black
        return result
    }()
    
    
    private lazy var timeLabel: UILabel = {
        let result = UILabel()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.textColor = .black
        return result
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let result  = UIActivityIndicatorView(style: .large)
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupBackgroundImage()
        
        setupLocationManager()
        
        initViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(onNavBarButtonClicked))
        rightButton.tintColor = .white
        
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc private func onNavBarButtonClicked() {
        
        let alert = UIAlertController(title: "City", message: "Enter city name", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        let ok = UIAlertAction(title: "Ok", style: .default) {
            (action) -> Void in
            if let textField = alert.textFields?.first {
                if let typedCity = textField.text, !typedCity.isEmpty {
                    self.loadCityWeather(city: typedCity)
                }
            }
        }
        alert.addAction(ok)
        alert.addTextField {
            textField -> Void in
            textField.placeholder = "City name"
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func initViews() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate(
            [
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ]
        )
        
        imageView.contentMode = .center
        view.addSubview(imageView)
        NSLayoutConstraint.activate(
            [
                imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
                imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                imageView.heightAnchor.constraint(equalToConstant: 50),
                imageView.widthAnchor.constraint(equalToConstant: 50)
            ]
        )
        
        view.addSubview(tempLabel)
        NSLayoutConstraint.activate([
            tempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tempLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(cityLabel)
        NSLayoutConstraint.activate([
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityLabel.bottomAnchor.constraint(equalTo: tempLabel.topAnchor, constant: -8)
        ])
        
        view.addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 8)
        ])
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupNavBar() {
        if let navigationController = navigationController {
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.isTranslucent = true
            navigationController.view.backgroundColor = .clear
        }
    }
    
    private func setupBackgroundImage() {
        let background = UIImage(named: "weatherBackground")
        var imageViewBackground : UIImageView
        imageViewBackground = UIImageView(frame: view.bounds)
        imageViewBackground.contentMode =  .scaleAspectFill
        imageViewBackground.clipsToBounds = true
        imageViewBackground.image = background
        imageViewBackground.center = view.center
        view.addSubview(imageViewBackground)
        self.view.sendSubviewToBack(imageViewBackground)
    }
    
    private func showCurrentTime() {
        let currentTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .long
        timeLabel.text = dateFormatter.string(from: currentTime)
    }
    
    private func loadCityWeather(city: String) {
        activityIndicator.startAnimating()
        networkManager.getCurrentWeather(weatherType: .city(city: city), completion: handleResult)
    }
    
    private func loadLocalWeather(coords: CLLocationCoordinate2D) {
        networkManager.getCurrentWeather(weatherType: WeatherType.local(latitude: String(coords.latitude), longitude: String(coords.longitude)), completion: handleResult)
    }

    private func initIcon(iconUrl: URL) {
        downloadImage(from: iconUrl)
    }
    
    private func initInfo(temp: Double, city: String) {
        DispatchQueue.main.async() { [weak self] in
            let measurementFormatter = MeasurementFormatter()
            measurementFormatter.numberFormatter.maximumFractionDigits = 0
            measurementFormatter.unitOptions = .providedUnit
            let result = Measurement(value: temp, unit: UnitTemperature.kelvin).converted(to: UnitTemperature.celsius)
            self?.tempLabel.text = String(measurementFormatter.string(from: result))
            self?.cityLabel.text = city
            self?.showCurrentTime()
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    private func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.imageView.image = UIImage(data: data)
                self?.activityIndicator.stopAnimating()
            }
        }
    }

}

extension CurrentWeatherViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        
        if currentLocation.horizontalAccuracy > 0 {
            manager.stopUpdatingLocation()
            let coords = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            loadLocalWeather(coords: coords)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
           manager.stopUpdatingLocation()
           return
        }
    }
}
