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
    
    func register(fullName: String, email: String, password: String) {
        let url = "http://localhost:1337/api/v1/entrance/signup"
        let params = ["fullName": fullName, "emailAddress": email, "password": password]
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseData { (dataResponse) in
                if let err = dataResponse.error {
                    print("Failed to sign up: ", err)
                    self.registerResponse = false
                    return
                }
                print("Successfully signed up...")
                self.registerResponse = true
        }
    }
}
