//
//  HomePresenter.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 27.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol HomePresenterProtocol: class {
    func numberOfItems() -> Int
    func searchTapped()
    func createPostsTapped()
    func logInTapped()
    func imagePickerDidCancel()
    func didSelectImage(with info: Any)
    func cellType(for indexPath: IndexPath) -> PostCellType?
    func updateDataSource()
    func configureView()
    func deletePost()
    func refresh()
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
        view?.addResfreshControl()
        interactor.fetchPosts()
    }
    
    func searchTapped() {
        router.showSearch()
    }
    
    func createPostsTapped() {
        router.showImagePicker()
    }
    
    func imagePickerDidCancel() {
        router.dismissImagePicker()
    }
    
    func didSelectImage(with info: Any) {
        router.showNewPostScreen(with: info, delegate: self)
    }
    
    func logInTapped() {
        router.showLoginScreen()
    }
    
    func numberOfItems() -> Int {
        return interactor.posts.count
    }
    
    func cellType(for indexPath: IndexPath) -> PostCellType? {
        return interactor.posts[indexPath.row].toPostCellType()
    }
    
    func updateDataSource() {
        view?.updateView()
        view?.endRefreshing()
    }
    
    func deletePost() {
        let row = interactor.deletePost()
        view?.deleteRow(from: IndexPath(row: row, section: 0))
    }
    
    func refresh() {
        interactor.fetchPosts()
    }
}

extension HomePresenter: NewPostModuleDelegate, PostCellDelegate {
    func didLikedPost() {
        print("Liked/Unliked")
    }
    
    func didCommentsTapped(postId: String) {
        router.showComments(postId: postId)
    }
    
    func didCreatePost() {
        interactor.fetchPosts()
    }
}
