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
    var html: String! { get set }
    var numberOfRows: Int? { set get }
    func fetchPostsTapped()
    func createPostsTapped()
    func logInTapped()
    func cellAuthor(for indexPath: IndexPath) -> NSAttributedString
    func cellText(for indexPath: IndexPath) -> NSAttributedString
    func cellImage(for indexPath: IndexPath) -> String
    func didCancelImagePicker()
    func didSelectImage(with info: Any)
}

class HomePresenter: HomePresenterProtocol {
    
    weak var view: HomeViewProtocol?
    
    required init(view: HomeViewProtocol) {
        self.view = view
    }
    
    var interactor: HomeInteractorProtocol!
    
    var router: HomeRouterProtocol!
    
    var html: String! {
        didSet {
            view?.presentWebView(with: html)
        }
    }
    
    var posts: [Post]? {
        didSet {
            numberOfRows = posts?.count
        }
    }
    
    var numberOfRows: Int? {
        didSet {
            view?.updateView()
        }
    }
    
    func fetchPostsTapped() {
        interactor.fetchPosts { (posts, err) in
            if err != nil {
                return
            }
            guard let posts = posts else { return }
            self.posts = posts
        }
    }
    
    func createPostsTapped() {
        router.showImagePicker()
    }
    
    func didCancelImagePicker() {
        router.dismissImagePicker()
    }
    
    func didSelectImage(with info: Any) {
        interactor.didSelectImage(with: info)
        router.dismissImagePicker()
    }
    
    func logInTapped() {
        router.showLoginScreen()
    }
    
    func cellAuthor(for indexPath: IndexPath) -> NSAttributedString {
        let attrText = NSAttributedString(string: posts?[indexPath.row].user.fullName ?? "")
        return attrText
    }
    
    func cellText(for indexPath: IndexPath) -> NSAttributedString {
        let attrText = NSAttributedString(string: posts?[indexPath.row].text ?? "")
        return attrText
    }
    
    func cellImage(for indexPath: IndexPath) -> String {
        return posts?[indexPath.row].imageUrl ?? ""
    }
}
