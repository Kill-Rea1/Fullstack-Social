//
//  LikesConfigurator.swift
//  Likes
//
//  Created by Kirill Ivanov on 02.11.2019.
//

import Foundation
import UIKit

protocol LikesConfiguratorProtocol: class {
    func configure(with viewController: LikesController)
}

class LikesConfigurator: LikesConfiguratorProtocol {
    func configure(with viewController: LikesController) {
        let presenter = LikesPresenter(view: viewController)
        let interactor = LikesInteractor(presenter: presenter)
        let router = LikesRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
