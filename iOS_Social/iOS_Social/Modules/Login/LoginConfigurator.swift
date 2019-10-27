//
//  LoginConfigurator.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 27.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol LoginConfiguratorProtocol: class {
    func configure(with viewController: LoginController)
}

class LoginConfigurator: LoginConfiguratorProtocol {
    func configure(with viewController: LoginController) {
        let presenter = LoginPresenter(view: viewController)
        let interactor = LoginInteractor(presenter: presenter)
        let router = LoginRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        
    }
}
