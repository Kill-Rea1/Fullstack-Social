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
    func fetchPosts()
    func findPost(with id: String)
    func deletePost() -> Int
}

class HomeInteractor: HomeInteractorProtocol {
    
    weak var presenter: HomePresenterProtocol?
    
    var selectedPost: Post?
    
    required init(presenter: HomePresenterProtocol) {
        self.presenter = presenter
    }
    
    // MARK:- HomeInteractorProtocol
    
    var serverService: ServerServiceProtocol = ServerService()
    
    var posts: [Post]! = []
    
    func fetchPosts() {
        serverService.fetchPosts { (res) in
            switch res {
            case .failure(_):
                return
            case .success(let posts):
                self.posts = posts
                self.presenter?.updateDataSource()
            }
        }
    }
    
    func findPost(with id: String) {
        selectedPost = posts?.first(where: { (post) -> Bool in
            return post.id == id
        })
    }
    
    func deletePost() -> Int {
        guard let id = selectedPost?.id else { return 0}
        guard let row = posts.firstIndex(where: { (post) -> Bool in
            return post.id == id
        }) else { return 0}
        posts?.remove(at: row)
        serverService.deletePost(with: id)
        return row
    }
}
