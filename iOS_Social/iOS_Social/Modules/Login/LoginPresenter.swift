//
//  LoginPresenter.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 27.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol LoginPresenterProtocol: class {
    var interactor: LoginInteractorProtocol! { get set }
    var router: LoginRouterProtocol! { get set }
    func loginButtonTapped()
    func emailChanged(to email: String)
    func passwordChanged(to password: String)
    func isSuccessfullyLoggedIn(success: Bool)
    func toRegisterButtonTapped()
}

class LoginPresenter: LoginPresenterProtocol {
    
    var email: String!
    var password: String!
    
    var interactor: LoginInteractorProtocol!
    var router: LoginRouterProtocol!
    weak var view: LoginViewProtocol?
    
    required init(view: LoginViewProtocol) {
        self.view = view
    }
    
    func loginButtonTapped() {
        view?.showHUD(with: "Loggin in")
        guard let _email = email, _email != "",
            let _password = password, _password != "" else {
            view?.hideHUD()
            return
        }
        interactor.login(email: _email, password: _password)
    }
    
    func toRegisterButtonTapped() {
        router.showRegisterScreen()
    }
    
    func emailChanged(to email: String) {
        self.email = email
    }
    
    func passwordChanged(to password: String) {
        self.password = password
    }
    
    func isSuccessfullyLoggedIn(success: Bool) {
        view?.hideHUD()
        if success {
            router.showHomeScreen()
        } else {
            view?.showErrorLabel()
        }
    }
}
