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
    func fetchPostsTapped()
    func logInTapped()
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
    
    func fetchPostsTapped() {
        interactor.fetchPosts()
    }
    
    func logInTapped() {
        router.showLoginScreen()
    }
}
