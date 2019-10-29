//
//  NewPostInteractor.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 28.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import Alamofire

protocol NewPostInteractorProtocol: class {
    var serverService: ServerServiceProtocol { get set }
    func savePost(postText: String, imageData: Data)
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
        serverService.delegate = self
        serverService.uploadPost(postText: postText, imageData: imageData) { (res) in
            switch res {
            case .failure:
                self.successfulCreation = false
            case .success:
                self.successfulCreation = true
            }
        }
    }
}

extension NewPostInteractor: UploadProgressProtocol {
    func progressDidChange(progress: Double) {
        presenter?.progress(is: progress)
    }
}
