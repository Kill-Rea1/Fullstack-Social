//
//  LoginRouter.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 27.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol LoginRouterProtocol: class {
    func showHomeScreen()
}

class LoginRouter: LoginRouterProtocol {
    weak var viewController: LoginController?
    
    required init(viewController: LoginController) {
        self.viewController = viewController
    }
    
    func showHomeScreen() {
        viewController?.dismiss(animated: true)
    }
}
