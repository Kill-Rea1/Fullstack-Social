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
    var posts: [Post]! { get }
//    func didSelectImage(with info: Any)
//    func fetchPosts(completionHandler: @escaping ([Post]?, Error?) -> ())
    func fetchPosts()
}

class HomeInteractor: HomeInteractorProtocol {
    
    weak var presenter: HomePresenterProtocol?
    
    required init(presenter: HomePresenterProtocol) {
        self.presenter = presenter
    }
    
    // MARK:- HomeInteractorProtocol
    
    var serverService: ServerServiceProtocol = ServerService()
    
    var posts: [Post]! = []
    
    func fetchPosts() {
        serverService.fetchPosts { (res) in
            switch res {
            case .failure(let err):
                print("Failed to fetch posts: ", err)
            case .success(let posts):
                self.posts = posts
            }
        }
    }
}
