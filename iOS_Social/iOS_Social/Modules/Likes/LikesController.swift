//
//  LikesController.swift
//  Likes
//
//  Created by Kirill Ivanov on 02.11.2019.
//

import Foundation
import UIKit
import JGProgressHUD

protocol LikesViewProtocol: class {
    func showHUD(with text: String)
    func hideHUD()
    func reloadData()
}

class LikesController: BaseCollectionController, LikesViewProtocol {
    
    init(postId: String) {
        self.postId = postId
        super.init()
    }
    private var postId: String
    var presenter: LikesPresenterProtocol!
    let configurator: LikesConfiguratorProtocol = LikesConfigurator()
    private let cellId = "userLike"
    private var hud: JGProgressHUD!

    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.postId = postId
        collectionView.backgroundColor = .white
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: cellId)
        navigationItem.title = "Likes"
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func showHUD(with text: String) {
        hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = text
        hud.show(in: view)
    }
    
    func hideHUD() {
        hud.dismiss()
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}

extension LikesController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserCellProtocol
        cell.userCellType = presenter.getUserCellType(for: indexPath)
        return cell as! UICollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItem(at: indexPath)
    }
}
