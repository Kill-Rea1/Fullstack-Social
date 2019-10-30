//
//  ProfileInteractor.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 29.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol ProfileInteractorProtocol: class {
    var user: User! { get set }
    var posts: [Post]! { get set }
    func loadProfile(with id: String)
    func changeFollowState()
    func didSelectImage(with info: Any)
}

class ProfileInteractor: ProfileInteractorProtocol {
    weak var presenter: ProfilePresenterProtocol?
    var serverService: ServerServiceProtocol = ServerService()
    
    required init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
    }
    
    var user: User! {
        didSet {
            posts = user.posts ?? []
        }
    }
    var posts: [Post]! = []
    
    func loadProfile(with id: String) {
        serverService.fetchUser(with: id) { (res) in
            switch res {
            case .failure(_):
                return
            case .success(let user):
                self.user = user
                self.presenter?.updateView()
            }
        }
    }
    
    func changeFollowState() {
        user.isFollowing = !(user.isFollowing ?? false)
        serverService.changeFollowState(of: user.id, state: !(user.isFollowing ?? true)) { (res) in
            switch res {
            case .failure(_):
                return
            case .success(_):
                self.presenter?.updateView()
            }
        }
    }
    
    func didSelectImage(with info: Any) {
        serverService.delegate = self
        serverService.uploadNewAvatar(with: info, fullName: user.fullName, bio: user.bio ?? "") { (res) in
            switch res {
            case .failure(_):
                return
            case .success(_):
                self.loadProfile(with: "")
            }
        }
    }
}

extension ProfileInteractor: UploadProgressProtocol {
    func progressDidChange(progress: Double) {
        presenter?.progress(is: progress)
    }
}
