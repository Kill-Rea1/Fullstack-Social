//
//  HomeConfigurator.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 27.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol HomeConfiguratorProtocol: class {
    func configure(with viewController: HomeController)
}

class HomeConfigurator: HomeConfiguratorProtocol {
    
    func configure(with viewController: HomeController) {
        let presenter = HomePresenter(view: viewController)
        let interactor = HomeInteractor(presenter: presenter)
        let router = HomeRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
