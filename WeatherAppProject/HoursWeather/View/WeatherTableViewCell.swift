//
//  WeatherTableViewCell.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 18.07.2021.
//

import UIKit


/// Кастомная ячейка для отображения погоды по часам
class WeatherTableViewCell: UITableViewCell {
    
    /// Идентификатор ячейка
    static let identifier = "WeatherTableViewCell"
    
    lazy private var timeLabel: UILabel = {
        let result = UILabel()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.textColor = .white
        result.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        return result
    }()
    
    lazy private var temperatureLabel: UILabel = {
        let result = UILabel()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.textColor = .white
        result.font = UIFont(name: "ArialRoundedMTBold", size: 14)
        return result
    }()

    lazy private var humidityLabel: UILabel = {
        let result = UILabel()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.textColor = .white
        result.font = UIFont(name: "ArialRoundedMTBold", size: 14)
        return result
    }()

    lazy private var descriptionLabel: UILabel = {
        let result = UILabel()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.textColor = .white
        result.font = UIFont(name: "ArialRoundedMTBold", size: 14)
        return result
    }()

    lazy private var windLabel: UILabel = {
        let result = UILabel()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.textColor = .white
        result.font = UIFont(name: "ArialRoundedMTBold", size: 14)
        return result
    }()
    
    lazy private var image: UIImageView = {
        let result = UIImageView()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.contentMode = .scaleAspectFit
        return result
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        contentView.addSubview(image)
        contentView.addSubview(timeLabel)
        contentView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        contentView.layer.cornerRadius = 10
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(humidityLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(windLabel)
        
        selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.heightAnchor.constraint(equalToConstant: 100),
            image.widthAnchor.constraint(equalToConstant: 100),
            
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor),
            
            
            temperatureLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
            temperatureLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor),
            
            
            humidityLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
            humidityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            descriptionLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 4),
            
            windLabel.topAnchor.constraint(equalTo: humidityLabel.bottomAnchor, constant: 4),
            windLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            contentView.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: 8)
        ])
        super.updateConstraints()
    }
    
    
    /// Обновить ячейку
    /// - Parameter weater: модель с информацией для отображения
    func updateView(weater: HoursCellModel){
        timeLabel.text = weater.time
        temperatureLabel.text = weater.temperature
        humidityLabel.text = weater.humidity
        descriptionLabel.text = weater.description
        windLabel.text = weater.wind
        // todo можно вынести это в модель
        if  let imageId = weater.imageId,
            let iconUrl = URL(string: "https://openweathermap.org/img/wn")?
            .appendingPathComponent("\(imageId)@2x")
            .appendingPathExtension("png") {
        image.loadImage(url: iconUrl)
        }
    }
    
}
