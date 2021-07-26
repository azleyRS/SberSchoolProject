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
        
        self.navigationController!.navigationBar.barStyle = .black
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        
        initViews()
        tableView.separatorStyle = .none
        // presenter
        presenter.setViewDelegate(delegate: self)
        self.navigationController?.navigationItem.title = "123"
        
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onSaveClick))
    }
    
    @objc func onSaveClick() {
        print("onSaveClick")
        presenter.saveWeather()
    }
    
    @objc func onNavBarButtonClicked() {
        let alert = UIAlertController(title: "City", message: "Enter city name", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        let ok = UIAlertAction(title: "Ok", style: .default) {
            (action) -> Void in
            if let textField = alert.textFields?.first {
                if let typedCity = textField.text, !typedCity.isEmpty {
                    self.presenter.loadHoursCityWeather(city: typedCity)
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
        return presenter.weatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath)
        if let weatherCell = cell as? WeatherTableViewCell {
            weatherCell.updateView(weater: presenter.weatherData[indexPath.row])
        }
        return cell
    }
}

extension HoursWeatherViewController: HoursPresenterDelegateProtocol {
    
    func showLocalHoursWeather() {   
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setTitle(title: String) {
        DispatchQueue.main.async {
            self.navigationItem.title = title
        }
    }
}
