//
//  RegisterPresenter.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 28.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol RegisterPresenterProtocol: class {
    func fullNameChanged(to text: String?)
    func emailChanged(to text: String?)
    func passwordChanged(to text: String?)
    func registerButtonTapped()
    func toLoginButtonTapped()
    func isSuccessfullyRegistered(success: Bool)
}

class RegisterPresenter: RegisterPresenterProtocol {
    
    weak var view: RegisterViewProtocol?
    var fullName: String!
    var email: String!
    var password: String!
    
    required init(view: RegisterViewProtocol) {
        self.view = view
    }
    
    // MARK:- RegisterPresenterProtocol
    
    var interactor: RegisterInteractorProtocol!
    
    var router: RegisterRouterProtocol!
    
    func fullNameChanged(to text: String?) {
        fullName = text
    }
    
    func emailChanged(to text: String?) {
        email = text
    }
    
    func passwordChanged(to text: String?) {
        password = text
    }
    
    func registerButtonTapped() {
        view?.showHUD(with: "Registering")
        guard let _fullName = fullName, _fullName != "",
            let _email = email, _email != "",
            let _password = password, _password != "" else {
                view?.hideHUD()
                return
        }
        interactor.register(fullName: _fullName, email: _email, password: _password)
    }
    
    func toLoginButtonTapped() {
        router.showLoginScreen()
    }
    
    func isSuccessfullyRegistered(success: Bool) {
        view?.hideHUD()
        if success {
            router.showHomeScreen()
        } else {
            view?.showErrorLabel()
        }
    }
}
