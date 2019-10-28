//
//  HomePresenter.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 27.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol HomePresenterProtocol: class {
    var interactor: HomeInteractorProtocol! { get set }
    var router: HomeRouterProtocol! { get set }
    func numberOfRows() -> Int
    func fetchPostsTapped()
    func createPostsTapped()
    func logInTapped()
    func didCancelImagePicker()
    func didSelectImage(with info: Any)
    func cellType(for indexPath: IndexPath) -> PostCellType?
    func updateDataSource()
}

class HomePresenter: HomePresenterProtocol {
    
    weak var view: HomeViewProtocol?
    
    required init(view: HomeViewProtocol) {
        self.view = view
    }
    
    // MARK:- HomePresenterProtocol
    
    var interactor: HomeInteractorProtocol!
    
    var router: HomeRouterProtocol!
    
    func fetchPostsTapped() {
        interactor.fetchPosts()
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
}

extension HomePresenter: NewPostModuleDelegate {
    func didCreatePost() {
        interactor.fetchPosts()
    }
}
