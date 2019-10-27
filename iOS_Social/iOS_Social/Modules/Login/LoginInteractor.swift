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
    
    func login(email: String, password: String) {
        let url = "http://localhost:1337/api/v1/entrance/login"
        let params = ["emailAddress": email, "password": password]
        Alamofire.request(url, method: .put, parameters: params, encoding: URLEncoding())
            .validate(statusCode: 200..<300)
            .responseData { (dataResponse) in
                print("Finally send request to server..")
                if let _ = dataResponse.error {
                    self.loginResponse = false
                    return
                }
                self.loginResponse = true
            }
    }
}
