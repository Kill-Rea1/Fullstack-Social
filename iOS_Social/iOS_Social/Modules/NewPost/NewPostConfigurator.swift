//
//  NewPostConfigurator.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 28.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol NewPostConfiguratorProtocol: class {
    func configure(with viewController: NewPostController)
}

class NewPostConfigurator: NewPostConfiguratorProtocol {
    func configure(with viewController: NewPostController) {
        let presenter = NewPostPresenter(view: viewController)
        let interactor = NewPostInteractor(presenter: presenter)
        let router = NewPostRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        presenter.delegate = viewController.delegate
    }
}
