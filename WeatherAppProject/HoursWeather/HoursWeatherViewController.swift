//
//  HoursWeatherViewController.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 17.07.2021.
//

import UIKit
import CoreLocation

class HoursWeatherViewController: UIViewController {
        
    private let presenter: HoursPresenter
    private let locationManager = CLLocationManager()
    
    private var weatherData = [HoursCellModel]()
    
    lazy var tableView: UITableView = {
        let result = UITableView()
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    init(presenter: HoursPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        
        // presenter
        presenter.setViewDelegate(delegate: self)
        
        if let coordinate = locationManager.location?.coordinate {
            presenter.loadHoursWeather(lat: String(coordinate.latitude), lon: String(coordinate.longitude))
        }
        
    }
    
    func initViews() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ]
        )
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let rightButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(onNavBarButtonClicked))
        rightButton.tintColor = .white
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func onNavBarButtonClicked() {
        presenter.onNavBarButtonClicked()
    }
    
}

extension HoursWeatherViewController : UITableViewDelegate {
    
    // Удалить?
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension HoursWeatherViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath)
        
        print(weatherData)
        if let weatherCell = cell as? WeatherTableViewCell {
            weatherCell.updateView(weater: weatherData[indexPath.row])
        }
        
        return cell
    }
}

extension HoursWeatherViewController: HoursPresenterDelegateProtocol {
    func showLocalHoursWeather(result: FiveDaysWeatherModel) {
        var ressss = [HoursCellModel]()
        
        let cityName = result.city.name
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.numberFormatter.maximumFractionDigits = 0
        measurementFormatter.unitOptions = .providedUnit
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        
        func getTemp(_ temp : Double) -> String {
            let result = Measurement(value: temp, unit: UnitTemperature.kelvin).converted(to: UnitTemperature.celsius)
            return measurementFormatter.string(from: result)
        }
        
        func getTime(_ time: Int) -> String {
            return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(time)))
        }
        
        result.list.forEach { item in
            ressss.append(HoursCellModel(city: cityName, time: getTime(item.dt), temperature: getTemp(item.main.temp), description: item.weather.first!.weatherDescription, humidity: "Humidity is \(item.main.humidity)", wind: "Wind is \(item.wind.speed)"))
        }
        
        weatherData = ressss
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }

}
