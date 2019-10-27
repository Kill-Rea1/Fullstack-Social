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
        view?.showLoginHUD(with: "Loggin in")
        guard let _email = email, _email != "" else { return }
        guard let _password = password, _password != "" else { return }
        interactor.login(email: _email, password: _password)
        view?.hideLoginHUD()
        router.showHomeScreen()
    }
    
    func emailChanged(to email: String) {
        self.email = email
    }
    
    func passwordChanged(to password: String) {
        self.password = password
    }
}
