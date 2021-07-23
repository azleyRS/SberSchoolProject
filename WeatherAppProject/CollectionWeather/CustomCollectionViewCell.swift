//
//  CustomCollectionViewCell.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 22.07.2021.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CustomCollectionViewCell"
    
    var isEditing: Bool = false {
        didSet {
            editingCircle.isHidden = !isEditing
        }
    }
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "house")
        imageView.tintColor = .cyan
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    private let editingCircle: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle")
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.text = "Custom"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.addSubview(editingCircle)
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
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
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
    
    func updateCellInfo(title: String) {
        self.label.text = title
    }
}
