//
//  LikesPresenter.swift
//  Likes
//
//  Created by Kirill Ivanov on 02.11.2019.
//

import Foundation

protocol LikesPresenterProtocol: class {
    var postId: String! { get set }
    func numberOfItems() -> Int
    func getUserCellType(for indexPath: IndexPath) -> UserCellType
    func updateView()
    func didSelectItem(at indexPath: IndexPath)
}

class LikesPresenter: LikesPresenterProtocol {

    var router: LikesRouterProtocol!
    var interactor: LikesInteractorProtocol!
    weak var view: LikesViewProtocol?
    
    required init(view: LikesViewProtocol) {
        self.view = view
    }
    
    var postId: String! {
        didSet {
            view?.showHUD(with: "Loading..")
            interactor.fetchUsers(with: postId)
        }
    }
    
    func numberOfItems() -> Int {
        return interactor.numberOfItems()
    }
    
    func getUserCellType(for indexPath: IndexPath) -> UserCellType {
        return interactor.getUserCellType(for: indexPath.item)
    }
    
    func updateView() {
        view?.reloadData()
        view?.hideHUD()
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        let userId = interactor.getUserId(for: indexPath.item)
        router.showProfile(with: userId)
    }
}
