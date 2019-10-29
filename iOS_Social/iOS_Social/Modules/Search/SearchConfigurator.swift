//
//  SearchConfigurator.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 29.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol SearchConfiguratorProtocol: class {
    func configure(with viewController: SearchController)
}

class SearchConfigurator: SearchConfiguratorProtocol {
    func configure(with viewController: SearchController) {
        let presenter = SearchPresenter(view: viewController)
        let interactor = SearchInteractor(presenter: presenter)
        let router = SearchRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.router = router
        presenter.interactor = interactor
    }
}
