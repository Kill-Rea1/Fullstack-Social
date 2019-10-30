//
//  RegisterInteractor.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 28.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import Alamofire

protocol RegisterInteractorProtocol: class {
    var serverService: ServerServiceProtocol { get set }
    func register(fullName: String, email: String, password: String)
}

class RegisterInteractor: RegisterInteractorProtocol {
    weak var presenter: RegisterPresenterProtocol?
    var registerResponse: Bool! {
        didSet {
            presenter?.isSuccessfullyRegistered(success: registerResponse)
        }
    }
    
    required init(presenter: RegisterPresenterProtocol) {
        self.presenter = presenter
    }
    
    // MARK:- RegisterInteractorProtocol
    
    var serverService: ServerServiceProtocol = ServerService()
    
    func register(fullName: String, email: String, password: String) {
        serverService.register(fullName: fullName, email: email, password: password) { (res) in
            switch res {
            case .failure(_):
                self.registerResponse = false
            case .success:
                self.registerResponse = true
            }
        }
    }
}
