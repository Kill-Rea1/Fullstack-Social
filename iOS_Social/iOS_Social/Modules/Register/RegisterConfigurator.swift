//
//  RegisterConfigurator.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 28.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol RegisterConfiguratorProtocol: class {
    func configure(with viewController: RegisterController)
}

class RegisterConfigurator: RegisterConfiguratorProtocol {
    func configure(with viewController: RegisterController) {
        let presenter = RegisterPresenter(view: viewController)
        let interactor = RegisterInteractor(presenter: presenter)
        let router = RegisterRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
