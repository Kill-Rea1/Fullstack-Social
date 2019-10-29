//
//  ProfileController.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 29.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol ProfileViewProtocol: class {
    func updateView()
    func showHUD(with text: String)
    func hideHUD()
}

class ProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout, ProfileViewProtocol {
    
    private let cellId = "profilePostId"
    private let headerId = "profileHeaderId"
    private let configurator: ProfileConfiguratorProtocol = ProfileConfigurator()
    var presenter: ProfilePresenterProtocol!
    var userId: String!
    weak var delegate: ProfileModuleDelegate?
    private var hud: JGProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.profileId = userId
        presenter.delegate = delegate
        
        collectionView.backgroundColor = .white
        collectionView.register(UserPostCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.delaysContentTouches = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! ProfileHeaderProtocol
        headerView.profileHeaderType = presenter.profileHeaderType() ?? nil
        headerView.delegate = presenter as? ProfileHeaderDelegate
        return (headerView as! UICollectionReusableView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return .init(width: view.frame.width, height: presenter.isUserLoaded() ? 300 : 0)
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
    
    func showHUD(with text: String) {
        hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = text
        hud.show(in: view)
    }
    
    func hideHUD() {
        hud.dismiss()
    }
}