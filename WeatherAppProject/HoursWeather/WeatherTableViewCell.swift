//
//  WeatherTableViewCell.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 18.07.2021.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    static let identifier = "WeatherTableViewCell"
    
    lazy private var cityLabel: UILabel = {
        let result = UILabel()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.text = "City goes here"
        return result
    }()
    
    lazy private var timeLabel: UILabel = {
        let result = UILabel()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.text = "Time goes here"
        return result
    }()
    
    lazy private var temperatureLabel: UILabel = {
        let result = UILabel()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.text = "Temperature"
        return result
    }()
    
    lazy private var humidityLabel: UILabel = {
        let result = UILabel()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.text = "Humidity"
        return result
    }()
    
    lazy private var descriptionLabel: UILabel = {
        let result = UILabel()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.text = "Description"
        return result
    }()
    
    lazy private var windLabel: UILabel = {
        let result = UILabel()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.text = "Wind"
        return result
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cityLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(humidityLabel)
        contentView.addSubview(windLabel)
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 4),
            temperatureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            descriptionLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
            
            humidityLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 4),
            humidityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            windLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            windLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            contentView.bottomAnchor.constraint(equalTo: humidityLabel.bottomAnchor, constant: 8)
        ])
        super.updateConstraints()
    }
    
    // убрать мб
    func updateView(weater: HoursCellModel){
        cityLabel.text = weater.city
        timeLabel.text = weater.time
        temperatureLabel.text = weater.temperature
        descriptionLabel.text = weater.description
        humidityLabel.text = weater.humidity
        windLabel.text = weater.wind
    }
    
}
