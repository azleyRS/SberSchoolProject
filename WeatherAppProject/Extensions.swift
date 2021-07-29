//
//  Extensions.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 23.07.2021.
//

import Foundation
import UIKit

var imageCash = NSCache<NSString, UIImage>()

// в идеале бы в сервис вынести, но неохота тащить UIKit сквозь все слои
extension UIImageView {
    func loadImage(url: URL) {
        
        if let image = imageCash.object(forKey: url.absoluteString as NSString) {
            self.image = image
            return
        }
        
        DispatchQueue.global().async {
            [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageCash.setObject(image, forKey: url.absoluteString as NSString)
                        self?.image = image
                    }
                }
            }
        }
    }
}
