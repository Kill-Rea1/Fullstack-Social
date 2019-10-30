//
//  LoginInteractor.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 27.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import Alamofire

protocol LoginInteractorProtocol: class {
    var serverService: ServerServiceProtocol { get set }
    func login(email: String, password: String)
}

class LoginInteractor: LoginInteractorProtocol {
    weak var presenter: LoginPresenterProtocol?
    
    required init(presenter: LoginPresenterProtocol) {
        self.presenter = presenter
    }
    
    var loginResponse: Bool! {
        didSet {
            presenter?.isSuccessfullyLoggedIn(success: loginResponse)
        }
    }
    
    // MARK:- LoginInteractorProtocol
    
    var serverService: ServerServiceProtocol = ServerService()
    
    func login(email: String, password: String) {
        serverService.login(email: email, password: password) { (res) in
            switch res {
            case .failure(_):
                self.loginResponse = false
            case .success:
                self.loginResponse = true
            }
        }
    }
}
