//
//  ProfileController.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 29.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol ProfileViewProtocol: class {
    func updateView()
}

class ProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout, ProfileViewProtocol {
    
    private let cellId = "profilePostId"
    let configurator: ProfileConfiguratorProtocol = ProfileConfigurator()
    var presenter: ProfilePresenterProtocol!
    var userId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.profileId = userId
        
        collectionView.backgroundColor = .white
        collectionView.register(UserPostCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.delaysContentTouches = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserPostCellProtocol
        cell.postCellType = presenter.postCellType(for: indexPath)
        return (cell as! UICollectionViewCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let dummyCell = UserPostCell(frame: .init(x: 0, y: 0, width: width, height: 1000))
        dummyCell.postCellType = presenter.postCellType(for: indexPath)
        dummyCell.layoutIfNeeded()
        let size = dummyCell.systemLayoutSizeFitting(.init(width: width, height: 1000))
        let height = size.height
        return .init(width: width, height: height)
    }
    
    // MARK:- ProfileViewProtocol
    
    func updateView() {
        collectionView.reloadData()
    }
}
