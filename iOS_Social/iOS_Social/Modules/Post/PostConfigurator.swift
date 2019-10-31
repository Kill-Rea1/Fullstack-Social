//
//  PostConfigurator.swift
//  Post
//
//  Created by Kirill Ivanov on 01.11.2019.
//

import Foundation
import UIKit

protocol PostConfiguratorProtocol: class {
    func configure(with viewController: PostController)
}

class PostConfigurator: PostConfiguratorProtocol {
    func configure(with viewController: PostController) {
        let presenter = PostPresenter(view: viewController)
        let interactor = PostInteractor(presenter: presenter)
        let router = PostRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
