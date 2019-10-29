//
//  HomePresenter.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 27.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol HomePresenterProtocol: class {
    func numberOfRows() -> Int
    func searchTapped()
    func createPostsTapped()
    func logInTapped()
    func didCancelImagePicker()
    func didSelectImage(with info: Any)
    func cellType(for indexPath: IndexPath) -> PostCellType?
    func updateDataSource()
    func configureView()
    func deletePost()
}

class HomePresenter: HomePresenterProtocol {
    
    weak var view: HomeViewProtocol?
    var selectedId: String!
    
    required init(view: HomeViewProtocol) {
        self.view = view
    }
    
    // MARK:- HomePresenterProtocol
    
    var interactor: HomeInteractorProtocol!
    
    var router: HomeRouterProtocol!
    
    func configureView() {
        interactor.fetchPosts()
    }
    
    func searchTapped() {
        router.showSearch()
    }
    
    func createPostsTapped() {
        router.showImagePicker()
    }
    
    func didCancelImagePicker() {
        router.dismissImagePicker()
    }
    
    func didSelectImage(with info: Any) {
        router.showNewPostScreen(with: info, delegate: self)
    }
    
    func logInTapped() {
        router.showLoginScreen()
    }
    
    func numberOfRows() -> Int {
        return interactor.posts.count
    }
    
    func cellType(for indexPath: IndexPath) -> PostCellType? {
        return interactor.posts[indexPath.row].toPostCellType()
    }
    
    func updateDataSource() {
        view?.updateView()
    }
    
    func deletePost() {
        let row = interactor.deletePost()
        view?.deleteRow(from: IndexPath(row: row, section: 0))
    }
}

extension HomePresenter: NewPostModuleDelegate, PostCellDelegate {
    func didCreatePost() {
        interactor.fetchPosts()
    }
    
    func handleOptions(with id: String) {
        selectedId = id
        view?.showAlertSheet()
        interactor.findPost(with: id)
    }
}
