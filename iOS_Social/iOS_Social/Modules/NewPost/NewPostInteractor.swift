//
//  NewPostInteractor.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 28.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol NewPostInteractorProtocol: class {
    var serverService: ServerServiceProtocol { get set }
    func savePost(postText: String, imageData: Data)
    func removeObserver()
    func addObserver()
}

class NewPostInteractor: NewPostInteractorProtocol {
    
    weak var presenter: NewPostPresenterProtocol?
    var successfulCreation: Bool! {
        didSet {
            presenter?.isSuccessfulyCreated(successfulCreation)
        }
    }
    
    required init(presenter: NewPostPresenterProtocol) {
        self.presenter = presenter
    }
    
    // MARK:- NewPostInteractorProtocol
    
    var serverService: ServerServiceProtocol = ServerService()
    
    func savePost(postText: String, imageData: Data) {
        serverService.uploadPost(postText: postText, imageData: imageData) { (res) in
            switch res {
            case .failure:
                self.successfulCreation = false
            case .success:
                self.successfulCreation = true
            }
        }
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUploadProgress), name: .uploadProgress, object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    fileprivate func handleUploadProgress(notifitacion: Notification) {
        guard let userInfo = notifitacion.userInfo as? [String: Any] else { return }
        guard let fraction = userInfo["uploadProgress"] as? Double else { return }
        print(fraction)
        presenter?.progress(is: fraction)
    }
}
