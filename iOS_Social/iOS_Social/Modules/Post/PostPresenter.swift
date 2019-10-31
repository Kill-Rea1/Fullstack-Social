//
//  PostPresenter.swift
//  Post
//
//  Created by Kirill Ivanov on 01.11.2019.
//

import Foundation

protocol PostPresenterProtocol: class {
    
}

class PostPresenter: PostPresenterProtocol {

    var router: PostRouterProtocol!
    var interactor: PostInteractorProtocol!
    weak var view: PostViewProtocol?
    
    required init(view: PostViewProtocol) {
        self.view = view
    }
}
