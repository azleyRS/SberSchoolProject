//
//  CollectionWeatherViewController.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 19.07.2021.
//

import UIKit

class CollectionWeatherViewController: UIViewController {
    
    var collectionData = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (view.frame.size.width - 20) / 3
                                 , height: (view.frame.size.width - 20) / 3)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let result = UICollectionView(frame: .zero, collectionViewLayout: layout)
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()

        title = "Comments go here"
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addItem))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        //пулл ту рефреш интереса ради
        let refreshContrl = UIRefreshControl()
        refreshContrl.tintColor = .blue
        refreshContrl.addTarget(self, action: #selector(pullToRefreshAction), for: .valueChanged)
        collectionView.refreshControl = refreshContrl
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.navigationItem.rightBarButtonItem?.isEnabled = !editing
        collectionView.allowsMultipleSelection = editing
        
        // скрыть выбранные ранее ячейки
        collectionView.indexPathsForSelectedItems?.forEach {
            collectionView.deselectItem(at: $0, animated: false)
        }
        
        let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteItems))
        if editing {
            self.navigationItem.rightBarButtonItems?.append(deleteButton)
        } else {
            self.navigationItem.rightBarButtonItems?.removeLast()
        }
        
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            if let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell {
                cell.isEditing = editing
            }
        }
    }
    
    func initViews() {
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        NSLayoutConstraint.activate(
            [
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ]
        )
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        
        
    }
    
    @objc func addItem() {
        let text = "\(collectionData.count + 1)  🍎"
        collectionData.append(text)
        let indexPath = IndexPath(row: collectionData.count - 1, section: 0)
        collectionView.insertItems(at: [indexPath])
    }
    
    // можно удалить потом
    @objc func pullToRefreshAction() {
        addItem()
        collectionView.refreshControl?.endRefreshing()
    }
    
    @objc func deleteItems() {
        if let selected = collectionView.indexPathsForSelectedItems {
            // sorted т.к. порядок добавления в indexPathsForSelectedItems может быть рандомный
            let items = selected.map { $0.item }.sorted().reversed()
            for item in items {
                collectionData.remove(at: item)
            }
            collectionView.deleteItems(at: selected)
        }
    }
    
}

extension CollectionWeatherViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                
        if !self.isEditing {
            print(indexPath)
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .init(rawValue: "flip")
            transition.subtype = CATransitionSubtype.fromLeft
            self.navigationController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(DetailsViewController(text: collectionData[indexPath.item]), animated: false)
        }

    }
    
}

extension CollectionWeatherViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath)
        if let cell = cell as? CustomCollectionViewCell {
            cell.backgroundColor = .red
            cell.isEditing = isEditing
            cell.updateCellInfo(title: "title \(collectionData[indexPath.item])")
        }
        return cell
    }
    
    
    
}
