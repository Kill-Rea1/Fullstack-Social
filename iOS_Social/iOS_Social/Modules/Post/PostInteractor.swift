//
//  PostInteractor.swift
//  Post
//
//  Created by Kirill Ivanov on 01.11.2019.
//

import Foundation

protocol PostInteractorProtocol: class {
    
}

class PostInteractor: PostInteractorProtocol {

    weak var presenter: PostPresenterProtocol!
    
    required init(presenter: PostPresenterProtocol) {
        self.presenter = presenter
    }
}
