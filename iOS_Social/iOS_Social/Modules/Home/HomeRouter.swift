//
//  HomeRouter.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 27.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol HomeRouterProtocol: class {
    var imagePicker: UIImagePickerController? { get set }
    func showLoginScreen()
    func showImagePicker()
    func dismissImagePicker()
}

class HomeRouter: HomeRouterProtocol {
    
    weak var viewController: HomeController?
    
    var imagePicker: UIImagePickerController?
    
    required init(viewController: HomeController) {
        self.viewController = viewController
    }
    
    func showLoginScreen() {
        let navController = UINavigationController(rootViewController: LoginController())
        viewController?.present(navController, animated: true)
    }
    
    func showImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = viewController
        viewController?.present(imagePicker!, animated: true)
    }
    
    func dismissImagePicker() {
        imagePicker?.dismiss(animated: true)
    }
}
