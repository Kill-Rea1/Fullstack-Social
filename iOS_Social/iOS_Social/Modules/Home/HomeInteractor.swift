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
        serverService.fetchPosts { (posts, err) in
            if err != nil {
                return
            }
            guard let posts = posts else { return }
            self.posts = posts
            self.presenter?.updateDataSource()
        }
    }
    
    func deleteFeedItem(with id: String) {
        serverService.deleteFeedItem(with: id) { (_, err) in
            if err != nil {
                return
            }
            guard let item = self.posts.firstIndex(where: {$0.id == id}) else { return }
            self.posts.remove(at: item)
            self.presenter?.successfullyDeleted(at: item)
        }
    }
    
    func didLikedPost(with id: String) {
        guard let item = posts.firstIndex(where: {$0.id == id}) else { return }
        let likeState = posts[item].hasLiked == true
        serverService.didLikedPost(with: id, likeState: likeState) { (_, err) in
            if err != nil {
                return
            }
            self.posts[item].hasLiked?.toggle()
            self.posts[item].numLikes += likeState ? -1 : 1
            self.presenter?.updatePost(at: item)
        }
    }
}
