//
//  CollectionWeatherViewController.swift
//  WeatherAppProject
//
//  Created by Руслан Хомяков on 19.07.2021.
//

import UIKit
import CoreData

class CollectionWeatherViewController: UIViewController {
    
    private let presenter: CollectionWeatherPresenter
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        // 3 в ряд довольно много - надо заменить на 2 элемента в ряду
        layout.itemSize = CGSize(width: (view.frame.size.width - 20) / 2
                                 , height: (view.frame.size.width - 20) / 2)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        let result = UICollectionView(frame: .zero, collectionViewLayout: layout)
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    init(presenter: CollectionWeatherPresenter) {
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
        
        self.presenter.setViewDelegate(delegate: self)
        
        initViews()

        // мб стоит изменять заголовок в зависимости от наличия/отсутствия элементов
        //title = "Comments go here"
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addItem))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        //пулл ту рефреш интереса ради
        let refreshContrl = UIRefreshControl()
        refreshContrl.tintColor = .blue
        refreshContrl.addTarget(self, action: #selector(pullToRefreshAction), for: .valueChanged)
        collectionView.refreshControl = refreshContrl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadWeatherList()
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
        collectionView.register(HeaderCityCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCityCollectionReusableView.identifier)
    }
    
    @objc func addItem() {
        // удалить т.к. не будет тут добавления
        print("addItem")
//        let text = "\(collectionData.count + 1)  🍎"
//        collectionData.append(text)
//        let indexPath = IndexPath(row: collectionData.count - 1, section: 0)
//        collectionView.insertItems(at: [indexPath])
    }
    
    // можно удалить потом
    @objc func pullToRefreshAction() {
        // тоже можно удалить или заменить на анимацию какую
        addItem()
        collectionView.refreshControl?.endRefreshing()
    }
    
    @objc func deleteItems() {
        print("deleteItems")
        // а вот тут надо бы доделать удаление из CoreData и визуально
        
        if let selected = collectionView.indexPathsForSelectedItems {
            presenter.deleteItems(indexPaths: selected)
        }
    }
    
}

extension CollectionWeatherViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                
        if !self.isEditing {
            print(indexPath)
            // анимация эксперимента ради
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .init(rawValue: "flip")
            transition.subtype = CATransitionSubtype.fromLeft
            self.navigationController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(DetailsViewController(text: presenter.getCellModel(indexPath: indexPath).temperature), animated: false)
        }

    }
    
}

extension CollectionWeatherViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.fetchedRC?.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // в презентер?
        //presenter.fetchedRC?.fetchedObjects?.count ?? 0
        do{
            try presenter.fetchedRC?.performFetch()
        } catch {
            print("fetchedRC?.performFetch()")
        }
        
        guard let sections = presenter.fetchedRC?.sections,
              let objs = sections[section].objects else {
            return 0
        }
        
        return objs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath)
        
        // тут надо доработать ячейку
        if let cell = cell as? CustomCollectionViewCell {
            let weatherModel = presenter.getCellModel(indexPath: indexPath)
            cell.isEditing = isEditing
            cell.updateCellInfo(weatherModel: weatherModel)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCityCollectionReusableView.identifier, for: indexPath)
        if let header = header as? HeaderCityCollectionReusableView,
           let weatherModel = presenter.fetchedRC?.sections?[indexPath.section].objects?.first as? CoreDataWeatherEntity {
            header.configurate(city: weatherModel.city)
        }
        return header
    }
    
}

extension CollectionWeatherViewController: CollectionWeatherPresenterDelegateProtocol {
    func deleteItemsFromView(indexPaths: [IndexPath]) {
        self.collectionView.deleteItems(at: indexPaths)
    }
    
    func loadWeather() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension CollectionWeatherViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
}
