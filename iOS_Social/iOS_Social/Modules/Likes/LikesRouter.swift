//
//  LikesRouter.swift
//  Likes
//
//  Created by Kirill Ivanov on 02.11.2019.
//

import Foundation
import UIKit

protocol LikesRouterProtocol: class {
    func showProfile(with id: String)
}

class LikesRouter: LikesRouterProtocol {

    weak var viewController: LikesController?
    
    required init(viewController: LikesController) {
        self.viewController = viewController
    }
    
    func showProfile(with id: String) {
        let profileController = ProfileController(userId: id)
        viewController?.navigationController?.pushViewController(profileController, animated: true)
    }
}
