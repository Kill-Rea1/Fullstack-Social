//
//  HomeInteractor.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 27.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import Alamofire

protocol HomeInteractorProtocol: class {
    var serverService: ServerServiceProtocol { get set }
    func didSelectImage(with info: Any)
    func fetchPosts(completionHandler: @escaping ([Post]?, Error?) -> ())
}

class HomeInteractor: HomeInteractorProtocol {
    
    weak var presenter: HomePresenterProtocol?
    
    required init(presenter: HomePresenterProtocol) {
        self.presenter = presenter
    }
    
    var html: String! {
        didSet {
            presenter?.html = html
        }
    }
    
    var serverService: ServerServiceProtocol = ServerService()
    
    func didSelectImage(with info: Any) {
        serverService.uploadImage(info: info)
    }
    
    func fetchPosts(completionHandler: @escaping ([Post]?, Error?) -> ()) {
        serverService.fetchPosts { (res) in
            switch res {
            case .failure(let err):
                print("Failed to fetch posts: ", err)
                completionHandler(nil, err)
            case .success(let posts):
                completionHandler(posts, nil)
            }
        }
    }
}
