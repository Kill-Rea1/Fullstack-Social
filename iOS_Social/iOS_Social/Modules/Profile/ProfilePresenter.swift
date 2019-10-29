//
//  ProfilePresenter.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 29.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol ProfilePresenterProtocol: class {
    var profileId: String! { get set }
    func numberOfItems() -> Int
    func updateView()
    func postCellType(for indexPath: IndexPath) -> PostCellType?
}

class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewProtocol?
    var router: ProfileRouterProtocol!
    var interactor: ProfileInteractorProtocol!
    
    required init(view: ProfileViewProtocol) {
        self.view = view
    }
    
    // MARK:- ProfilePresenterProtocol
    
    var profileId: String! {
        didSet {
            interactor.loadProfile(with: profileId)
        }
    }
    
    func numberOfItems() -> Int {
        return interactor.posts.count
    }
    
    func updateView() {
        view?.updateView()
    }
    
    func postCellType(for indexPath: IndexPath) -> PostCellType? {
        return interactor.posts[indexPath.item].toPostCellType()
    }
}
