//
//  HeaderCityCollectionReusableView.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 27.07.2021.
//

import UIKit

class HeaderCityCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "HeaderCityCollectionReusableView"
    
    private let label: UILabel = {
       let result = UILabel()
        result.textColor = .white
        result.textAlignment = .center
        result.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        return result
    }()
    
    

    public func configurate(city: String) {
        label.text = city
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
}
