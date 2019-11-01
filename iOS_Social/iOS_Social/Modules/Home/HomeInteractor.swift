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
    func deleteFeedItem(with id: String)
    func didLikedPost(with id: String)
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
            case .failure(_):
                return
            case .success(let posts):
                self.posts = posts
                self.presenter?.updateDataSource()
            }
        }
    }
    
    func deleteFeedItem(with id: String) {
        serverService.deleteFeedItem(with: id) { (res) in
            switch res {
            case .failure(_):
                return
            case .success(_):
                guard let item = self.posts.firstIndex(where: {$0.id == id}) else { return }
                self.posts.remove(at: item)
                self.presenter?.successfullyDeleted(at: item)
            }
        }
    }
    
    func didLikedPost(with id: String) {
        guard let item = posts.firstIndex(where: {$0.id == id}) else { return }
        let likeState = posts[item].hasLiked == true
        serverService.didLikedPost(with: id, likeState: likeState) { (res) in
            switch res {
            case .failure(_):
                return
            case .success(_):
                self.posts[item].hasLiked?.toggle()
                self.presenter?.updatePost(at: item)
            }
        }
    }
}
