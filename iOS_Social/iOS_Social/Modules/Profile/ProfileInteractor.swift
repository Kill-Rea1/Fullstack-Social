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
    func fetchProfile(with id: String)
    func changeFollowState()
    func didSelectImage(with info: Any)
    func deletePost(with id: String)
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
    
    func fetchProfile(with id: String) {
        serverService.fetchUser(with: id) { (user, err) in
            if err != nil {
                return
            }
            guard let user = user else { return }
            self.user = user
            self.presenter?.updateView()
        }
    }
    
    func changeFollowState() {
        user.isFollowing = !(user.isFollowing ?? false)
        serverService.changeFollowState(of: user.id, state: !(user.isFollowing ?? true)) { (_, err) in
            if err != nil {
                return
            }
            self.presenter?.updateView()
        }
    }
    
    func didSelectImage(with info: Any) {
        serverService.delegate = self
        serverService.uploadNewAvatar(with: info, fullName: user.fullName, bio: user.bio ?? "") { (res) in
            switch res {
            case .failure(_):
                return
            case .success(_):
                self.fetchProfile(with: "")
            }
        }
    }
    
    func deletePost(with id: String) {
        serverService.deletePost(with: id) { (_, err) in
            if err != nil {
                return
            }
            guard let item = self.posts.firstIndex(where: {$0.id == id}) else { return }
            self.posts.remove(at: item)
            self.presenter?.successfullyDeleted(at: item)
        }
    }
}

extension ProfileInteractor: UploadProgressProtocol {
    func progressDidChange(progress: Double) {
        presenter?.progress(is: progress)
    }
}
