//
//  CustomCollectionViewCell.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 22.07.2021.
//

import UIKit


/// Кастомная вьюшка для отображения информации о погоде на экране с сохраненной погодой
class CustomCollectionViewCell: UICollectionViewCell {
    
    /// Идентификатор ячейки
    static let identifier = "CustomCollectionViewCell"
    
    /// маркер является ли ячейка редактируемой в данный момент
    var isEditing: Bool = false {
        didSet {
            editingCircle.isHidden = !isEditing
        }
    }
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        return imageView
    }()
    
    private let editingCircle: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle")
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let timeLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let temperatureLabel: UILabel = {
       let result = UILabel()
        result.textColor = .white
        result.textAlignment = .center
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(editingCircle)
        contentView.addSubview(temperatureLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            if isEditing {
                editingCircle.image = UIImage(systemName: isSelected ? "circle.fill" : "circle")
            }
        }
    }
    
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            timeLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            temperatureLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
            temperatureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            editingCircle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            editingCircle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            editingCircle.heightAnchor.constraint(equalToConstant: 16),
            editingCircle.widthAnchor.constraint(equalToConstant: 16)
        ])
        super.updateConstraints()
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    /// Обновить информацию во вьюшке
    /// - Parameter weatherModel: модель для отображения информации во вьюшке
    func updateCellInfo(weatherModel: HoursCellModel) {
        self.timeLabel.text = weatherModel.time
        
        if let imageId = weatherModel.imageId,
            let iconUrl = URL(string: "https://openweathermap.org/img/wn")?
            .appendingPathComponent("\(imageId)@2x")
            .appendingPathExtension("png") {
            self.imageView.loadImage(url: iconUrl)
        }
        
        self.temperatureLabel.text = weatherModel.temperature
    }
}
