//
//  HomeRouter.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 27.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol HomeRouterProtocol: class {
    func showLoginScreen()
}

class HomeRouter: HomeRouterProtocol {
    
    weak var viewController: HomeController?
    
    required init(viewController: HomeController) {
        self.viewController = viewController
    }
    
    func showLoginScreen() {
        let navController = UINavigationController(rootViewController: LoginController())
        viewController?.present(navController, animated: true)
    }
}
