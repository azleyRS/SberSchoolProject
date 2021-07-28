//
//  ViewController.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 11.07.2021.
//

import UIKit
import CoreLocation


/// ViewController для экрана с отображением текущей погоды
class CurrentWeatherViewController: UIViewController {
        
    private let presenter: CurrentWeatherPresenter
    private let locationManager = CLLocationManager()
    
    private lazy var weatherIconView: UIImageView = {
        let result = UIImageView()
        result.contentMode = .center
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let result = UILabel()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.textColor = .white
        result.font = UIFont(name: "EuphemiaUCAS-Bold", size: 30)
        // todo в презентер?
        result.text = "Loading temperature..."
        return result
    }()
    
    private lazy var cityLabel: UILabel = {
        let result = UILabel()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.textColor = .white
        result.font = UIFont(name: "EuphemiaUCAS-Bold", size: 30)
        return result
    }()
    
    
    private lazy var timeLabel: UILabel = {
        let result = UILabel()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.textColor = .white
        result.font = UIFont(name: "EuphemiaUCAS-Bold", size: 14)
        return result
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let result  = UIActivityIndicatorView(style: .large)
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    private lazy var imageViewBackground : UIImageView = {
        var imageViewBackground = UIImageView()
        imageViewBackground.contentMode =  .scaleAspectFill
        imageViewBackground.clipsToBounds = true
        imageViewBackground.translatesAutoresizingMaskIntoConstraints = false
        return imageViewBackground
    }()
    
    private lazy var toggle : UISwitch = {
        let toggle = UISwitch()
        return toggle
    }()
    
    private lazy var leftBarButtomSwithView : UIView = {
        let offLabel = UILabel()
        offLabel.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
        offLabel.textColor = .white
        offLabel.text = "Evening"

        let onLabel = UILabel()
        onLabel.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
        onLabel.textColor = .white
        onLabel.text = "Morning"

        toggle.addTarget(self, action: #selector(toggleValueChanged(_:)), for: .valueChanged)

        let stackView = UIStackView(arrangedSubviews: [offLabel, toggle, onLabel])
        stackView.spacing = 8
        return stackView
    }()
    
    /// Конструктор вьюКонтроллера экрана с текущей погодой
    /// - Parameter presenter: Презентер экрана с отображением текущей погоды
    init(presenter: CurrentWeatherPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.setViewDelegate(delegate: self)
        
        setupNavBar()
        
        setupLocationManager()
        
        initViews()
    }
    
    /// Обработка клика на свитче
    /// - Parameter toggle: Нажатый свитч
    @objc private func toggleValueChanged(_ toggle: UISwitch) {
        presenter.switchToggle(isEnabled: toggle.isOn)
    }
    
    /// Обработка нажатия на иконку поиска в навБаре
    @objc private func onNavBarButtonClicked() {
        
        let alert = UIAlertController(title: "City", message: "Enter city name", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        let ok = UIAlertAction(title: "Ok", style: .default) {
            (action) -> Void in
            if let textField = alert.textFields?.first {
                if let typedCity = textField.text, !typedCity.isEmpty {
                    self.presenter.getCurrentWeather(city: typedCity)
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
        setupBackgroundImage()
        
        // можно разом активировать, но так было удобнее
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate(
            [
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ]
        )
        
        view.addSubview(weatherIconView)
        NSLayoutConstraint.activate(
            [
                weatherIconView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
                weatherIconView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                weatherIconView.heightAnchor.constraint(equalToConstant: 50),
                weatherIconView.widthAnchor.constraint(equalToConstant: 50)
            ]
        )
        
        view.addSubview(temperatureLabel)
        NSLayoutConstraint.activate([
            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            temperatureLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(cityLabel)
        NSLayoutConstraint.activate([
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityLabel.bottomAnchor.constraint(equalTo: temperatureLabel.topAnchor, constant: -8)
        ])
        
        view.addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 8)
        ])
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupNavBar() {
        // настройка прозрачного тулбара
        if let navigationController = navigationController {
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.isTranslucent = true
            navigationController.view.backgroundColor = .clear
        }
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(onNavBarButtonClicked))
        rightButton.tintColor = .white
        navigationItem.rightBarButtonItem = rightButton

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButtomSwithView)
        presenter.handleTogglePosition()
    }
    
    /// Настройка фона экрана, в отдельной функции для удобства
    private func setupBackgroundImage() {
        view.addSubview(imageViewBackground)
        view.sendSubviewToBack(imageViewBackground)
        self.presenter.handleBackgroundImage()
        NSLayoutConstraint.activate(
            [
                imageViewBackground.topAnchor.constraint(equalTo: view.topAnchor),
                imageViewBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                imageViewBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                imageViewBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
    }
    
    private func showCurrentTime() {
        // todo в презентер?
        let currentTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .long
        timeLabel.text = dateFormatter.string(from: currentTime)
    }

    private func initInfo(temp: Double, city: String) {
        DispatchQueue.main.async() { [weak self] in
            let measurementFormatter = MeasurementFormatter()
            measurementFormatter.numberFormatter.maximumFractionDigits = 0
            measurementFormatter.unitOptions = .providedUnit
            let result = Measurement(value: temp, unit: UnitTemperature.kelvin).converted(to: UnitTemperature.celsius)
            self?.temperatureLabel.text = String(measurementFormatter.string(from: result))
            self?.temperatureLabel.font = UIFont(name: "EuphemiaUCAS-Bold", size: 50)

            self?.cityLabel.text = city
            self?.showCurrentTime()
        }
    }
}

extension CurrentWeatherViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        
        if currentLocation.horizontalAccuracy > 0 {
            manager.stopUpdatingLocation()
            let coords = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            presenter.loadLocalWeather(latitude: String(coords.latitude), longitude: String(coords.longitude))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
           manager.stopUpdatingLocation()
           return
        }
    }
}

extension CurrentWeatherViewController : CurrentWeatherPresenterDelegateProtocol {
    
    func showWeatherIcon(id: String) {
        // todo надо подумать что можно сделать, вынести загрузку в презентер или хотя бы формирование урла
        if let iconUrl = URL(string: "https://openweathermap.org/img/wn")?
         .appendingPathComponent("\(id)@2x")
            .appendingPathExtension("png") {
            self.weatherIconView.loadImage(url: iconUrl)
        }
    }
    
    func changeBackgroundImage(name: String) {
        imageViewBackground.image = UIImage(named: name)
    }
    
    func setSwitch(isEnabled: Bool) {
        toggle.setOn(isEnabled, animated: false)
    }
    
    func showLocalWeather2(presentationModel: CurrentWeatherPresentationModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = presentationModel.temperature
            self.cityLabel.text = presentationModel.city
            self.timeLabel.text = presentationModel.date
        }
    }
    
    func showWeatherIcon(imageData: Data) {
        DispatchQueue.main.async {
            self.weatherIconView.image = UIImage(data: imageData)
        }
    }
    
    func showAlert(title: String) {
        DispatchQueue.main.async {
            let errorAlert = UIAlertController(title: title, message: "Try again later", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    func startActivityIndicator() {
        self.activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
}
