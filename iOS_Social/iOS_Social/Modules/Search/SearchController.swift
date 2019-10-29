//
//  SearchController.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 29.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol SearchViewProtocol: class {
    func update()
    func updateItem(at indexPath: IndexPath)
}

class SearchController: UICollectionViewController, SearchViewProtocol, UICollectionViewDelegateFlowLayout {
    private let cellId = "cellId"
    let configurator: SearchConfiguratorProtocol = SearchConfigurator()
    var presenter: SearchPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        
        navigationItem.title = "Search"
        collectionView.backgroundColor = .white
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.delaysContentTouches = false
        
        presenter.configureView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchCellProtocol
        cell.searchCellType = presenter.userSearchType(for: indexPath)
        cell.delegate = presenter as? SearchCellDelegate
        return (cell as! UICollectionViewCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelect(at: indexPath)
    }
    
    // MARK:- SearchViewProtocol
    
    func update() {
        collectionView.reloadData()
    }
    
    func updateItem(at indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
}
