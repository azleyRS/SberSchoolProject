//
//  DetailsViewController.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 22.07.2021.
//

import UIKit

class DetailsViewController: UIViewController {
    
    lazy var label: UILabel = {
       let result = UILabel()
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    init(text: String) {
        super.init(nibName: nil, bundle: nil)
        self.label.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        initViews()
    }
    
    func initViews() {
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }


}
