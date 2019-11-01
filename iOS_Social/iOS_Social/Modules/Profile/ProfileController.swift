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
    func setup()
    func updateView()
    func showHUD(with text: String, isProgress: Bool)
    func hideHUD()
    func HUDProgress(progress: Float, text: String)
    func fetchUserProfile()
}

class ProfileController: BaseCollectionController, ProfileViewProtocol {
    
    init(userId: String) {
        self.userId = userId
        super.init()
    }
    
    private let cellId = "profilePostId"
    private let headerId = "profileHeaderId"
    private let configurator: ProfileConfiguratorProtocol = ProfileConfigurator()
    var presenter: ProfilePresenterProtocol!
    private let userId: String!
    weak var delegate: ProfileModuleDelegate?
    private var hud: JGProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.profileId = userId
        presenter.delegate = delegate
    }
    
    // MARK:- ProfileViewProtocol
    
    func setup() {
        collectionView.backgroundColor = .white
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.delaysContentTouches = false
    }
    
    func updateView() {
        collectionView.reloadData()
    }
    
    func showHUD(with text: String, isProgress: Bool) {
        hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = text
        if isProgress {
            hud.indicatorView = JGProgressHUDRingIndicatorView()
        }
        hud.show(in: view)
    }
    
    func hideHUD() {
        hud.dismiss()
    }
    
    func HUDProgress(progress: Float, text: String) {
        hud.progress = progress
        hud.textLabel.text = text
    }
    
    func fetchUserProfile() {
        guard let presenter = presenter else { return }
        presenter.refetchUserProfile()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK:- UICollectionViewController settings

extension ProfileController: UICollectionViewDelegateFlowLayout {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostCellProtocol
        cell.postCellType = presenter.postCellType(for: indexPath)
        cell.delegate = presenter as? PostCellDelegate
        return (cell as! UICollectionViewCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let dummyCell = PostCell(frame: .init(x: 0, y: 0, width: width, height: 1000))
        dummyCell.postCellType = presenter.postCellType(for: indexPath)
        dummyCell.layoutIfNeeded()
        let size = dummyCell.systemLayoutSizeFitting(.init(width: width, height: 1000))
        let height = size.height
        return .init(width: width, height: height)
    }
}

// MARK:- UIImagePickerDelegate

extension ProfileController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        presenter.imagePickerDidCancel()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        presenter.didSelectImage(with: info)
    }
}
