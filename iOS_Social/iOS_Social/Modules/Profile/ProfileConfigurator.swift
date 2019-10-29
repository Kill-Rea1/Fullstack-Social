//
//  ProfileConfigurator.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 29.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol ProfileConfiguratorProtocol: class {
    func configure(with viewController: ProfileController)
}

class ProfileConfigurator: ProfileConfiguratorProtocol {
    func configure(with viewController: ProfileController) {
        let presenter = ProfilePresenter(view: viewController)
        let interactor = ProfileInteractor(presenter: presenter)
        let router = ProfileRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
