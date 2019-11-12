//
//  SearchInteractor.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 29.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol SearchInteractorProtocol: class {
    var users: [User]! { get set }
    func fetchUsers()
    func changeFollowState(of userId: String)
    func getId(for index: Int) -> String
}

class SearchInteractor: SearchInteractorProtocol {
    weak var presenter: SearchPresenterProtocol?
    
    var serverService: ServerServiceProtocol = ServerService()
    
    required init(presenter: SearchPresenterProtocol) {
        self.presenter = presenter
    }
    
    //MARK:- SearchInteractorProtocol
    
    var users: [User]! = []
    
    func fetchUsers() {
        serverService.searchForUsers { (users, err) in
            if err != nil {
                return
            }
            guard let users = users else { return }
            self.users = users
        }
    }
    
    func changeFollowState(of userId: String) {
        guard let index = users.firstIndex(where: { (user) -> Bool in
            return user.id == userId
        }) else { return }
        let isFollowing = users[index].isFollowing == true
        serverService.changeFollowState(of: userId, state: isFollowing) { (success, err) in
            if err != nil {
                return
            }
            self.users[index].isFollowing?.toggle()
            self.presenter?.updateItem(at: index)
        }
    }
    
    func getId(for index: Int) -> String {
        return users[index].id
    }
}
