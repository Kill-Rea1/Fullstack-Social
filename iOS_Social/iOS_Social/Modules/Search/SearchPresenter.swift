//
//  SearchPresenter.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 29.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol SearchPresenterProtocol: class {
    var router: SearchRouterProtocol! { get set }
    var interactor: SearchInteractorProtocol! { get set }
    func numberOfItems() -> Int
    func userSearchType(for indexPath: IndexPath) -> SearchCellType
    func configureView()
    func updateView()
    func updateItem(at index: Int)
}

class SearchPresenter: SearchPresenterProtocol {
    
    weak var view: SearchViewProtocol?
    
    required init(view: SearchViewProtocol) {
        self.view = view
    }
    
    // MARK:- SearchPresenterProtocol
    
    var router: SearchRouterProtocol!
    var interactor: SearchInteractorProtocol!
    
    func numberOfItems() -> Int {
        return interactor.users.count
    }
    
    func userSearchType(for indexPath: IndexPath) -> SearchCellType {
        return interactor.users[indexPath.item].toSearchType()
    }
    
    func configureView() {
        interactor.fetchUsers()
    }
    
    func updateView() {
        view?.update()
    }
    
    func updateItem(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        view?.updateItem(at: indexPath)
    }
}

// MARK:- SearchCellDelegate

extension SearchPresenter: SearchCellDelegate {
    func didFollow(withID id: String) {
        interactor.changeFollowState(of: id)
    }
}
