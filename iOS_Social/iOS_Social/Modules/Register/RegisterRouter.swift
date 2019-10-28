//
//  RegisterRouter.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 28.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol RegisterRouterProtocol: class {
    func showHomeScreen()
    func showLoginScreen()
}

class RegisterRouter: RegisterRouterProtocol {
    weak var viewController: RegisterController?
    
    required init(viewController: RegisterController) {
        self.viewController = viewController
    }
    
    func showHomeScreen() {
        viewController?.dismiss(animated: true)
    }
    
    func showLoginScreen() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
