//
//  NewPostPresenter.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 28.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol NewPostModuleDelegate: class {
    func didCreatePost()
}

protocol NewPostPresenterProtocol: class {
    var interactor: NewPostInteractorProtocol! { get set }
    var router: NewPostRouterProtocol! { get set }
    var delegate: NewPostModuleDelegate? { get set }
    func textViewDidChange(with text: String)
    func createPost()
    func progress(is progress: Double)
    func isSuccessfulyCreated(_ success: Bool)
}

class NewPostPresenter: NewPostPresenterProtocol {
    
    weak var view: NewPostViewProtocol?
    
    var postText: String!
    
    weak var delegate: NewPostModuleDelegate?
    
    required init(view: NewPostViewProtocol) {
        self.view = view
    }
    
    // MARK:- NewPostPresenterProtocol
    
    var interactor: NewPostInteractorProtocol!
    
    var router: NewPostRouterProtocol!
    
    func textViewDidChange(with text: String) {
        view?.changePlaceholderHidden(to: text.isEmpty)
        postText = text
    }
    
    func createPost() {
        guard let imageData = view?.getImageData(), postText != "" else { return }
        interactor.savePost(postText: postText, imageData: imageData)
        view?.showHUD(with: "Uploading")
    }
    
    func progress(is progress: Double) {
        view?.HUDProgress(progress: Float(progress), text: "Uploading\n\(Int(progress * 100))% Complete")
    }
    
    func isSuccessfulyCreated(_ success: Bool) {
        view?.hideHUD()
        if success {
            delegate?.didCreatePost()
            router.dismiss()
        }
    }
}
