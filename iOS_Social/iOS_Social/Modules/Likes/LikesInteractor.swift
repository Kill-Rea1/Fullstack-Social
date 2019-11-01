//
//  LikesInteractor.swift
//  Likes
//
//  Created by Kirill Ivanov on 02.11.2019.
//

import Foundation

protocol LikesInteractorProtocol: class {
    func fetchUsers(with id: String)
    func numberOfItems() -> Int
    func getUserCellType(for item: Int) -> UserCellType
    func getUserId(for item: Int) -> String
}

class LikesInteractor: LikesInteractorProtocol {

    weak var presenter: LikesPresenterProtocol!
    let serverService: ServerServiceProtocol = ServerService()
    var users = [User]()
    
    required init(presenter: LikesPresenterProtocol) {
        self.presenter = presenter
    }
    
    func fetchUsers(with id: String) {
        serverService.fetchPostsLikes(with: id) { (res) in
            switch res {
            case .failure(_):
                return
            case .success(let users):
                self.users = users
                self.presenter?.updateView()
            }
        }
    }
    
    func numberOfItems() -> Int {
        return users.count
    }
    
    func getUserCellType(for item: Int) -> UserCellType {
        return users[item].toUserCellType()
    }
    
    func getUserId(for item: Int) -> String {
        return users[item].id
    }
}
