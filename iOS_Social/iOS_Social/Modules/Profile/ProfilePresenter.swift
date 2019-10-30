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
}

class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewProtocol?
    var router: ProfileRouterProtocol!
    var interactor: ProfileInteractorProtocol!
    
    required init(view: ProfileViewProtocol) {
        self.view = view
    }
    
    // MARK:- ProfilePresenterProtocol
    
    var profileId: String! {
        didSet {
            interactor.loadProfile(with: profileId)
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
}

extension ProfilePresenter: ProfileHeaderDelegate {
    func didFollow() {
        interactor.changeFollowState()
        delegate?.didChangeFollowState(for: interactor.user.id)
    }
    
    func changeAvatar() {
        router.showImagePicker()
    }
}
