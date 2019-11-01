//
//  ProfilePresenter.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 29.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol ProfilePresenterProtocol: class {
    var delegate: ProfileModuleDelegate? { get set }
    var profileId: String! { get set }
    func numberOfItems() -> Int
    func updateView()
    func postCellType(for indexPath: IndexPath) -> PostCellType?
    func profileHeaderType() -> ProfileHeaderType?
    func isUserLoaded() -> Bool
    func imagePickerDidCancel()
    func didSelectImage(with info: Any)
    func progress(is progress: Double)
    func refetchUserProfile()
    func deletePost()
    func successfullyDeleted(at item: Int)
}

class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewProtocol?
    var router: ProfileRouterProtocol!
    var interactor: ProfileInteractorProtocol!
    var selectedId: String!
    
    required init(view: ProfileViewProtocol) {
        self.view = view
        self.view?.setup()
    }
    
    // MARK:- ProfilePresenterProtocol
    
    var profileId: String! {
        didSet {
            interactor.fetchProfile(with: profileId)
            view?.showHUD(with: "Loading", isProgress: false)
        }
    }
    
    weak var delegate: ProfileModuleDelegate?
    
    func numberOfItems() -> Int {
        return interactor.posts.count
    }
    
    func updateView() {
        view?.updateView()
        view?.hideHUD()
        view?.endRefreshing()
    }
    
    func postCellType(for indexPath: IndexPath) -> PostCellType? {
        return interactor.posts[indexPath.item].toPostCellType()
    }
    
    func profileHeaderType() -> ProfileHeaderType? {
        guard let user = interactor.user else { return nil }
        return user.toProfileHeader()
    }
    
    func isUserLoaded() -> Bool {
        return interactor.user != nil
    }
    
    func imagePickerDidCancel() {
        router.dismissImagePicker()
    }
    
    func didSelectImage(with info: Any) {
        view?.showHUD(with: "Updating profile", isProgress: true)
        interactor.didSelectImage(with: info)
        router.dismissImagePicker()
    }
    
    func progress(is progress: Double) {
        view?.HUDProgress(progress: Float(progress), text: "Uploading\n\(Int(progress * 100))% Complete")
    }
    
    func refetchUserProfile() {
        interactor.fetchProfile(with: "")
    }
    
    func deletePost() {
        interactor.deletePost(with: selectedId)
    }
    
    func successfullyDeleted(at item: Int) {
        let indexPath = IndexPath(item: item, section: 0)
        view?.deleteItem(from: indexPath)
    }
}

// MARK:- PostCellDelegate

extension ProfilePresenter: PostCellDelegate {
    func showLikesButtonTapped(postId: String) {
        print("Tapped")
    }
    
    func didLikedPost(postId: String) {
        print("Liked/Unliked")
    }
    
    func didCommentsTapped(postId: String) {
        router.showComments(with: postId)
    }
    
    func didOptionsTapped(postId: String) {
        selectedId = postId
        view?.showAlertSheet()
    }
}

// MARK:- ProfileHeaderDelegate

extension ProfilePresenter: ProfileHeaderDelegate {
    func didFollowButtonTapped() {
        interactor.changeFollowState()
        delegate?.didChangeFollowState(for: interactor.user.id)
    }
    
    func changeAvatar() {
        router.showImagePicker()
    }
}
