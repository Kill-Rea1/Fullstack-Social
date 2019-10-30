//
//  ProfileRouter.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 29.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol ProfileRouterProtocol: class {
    func showImagePicker()
    func dismissImagePicker()
}

class ProfileRouter: ProfileRouterProtocol {
    weak var viewController: ProfileController?
    var imagePicker: UIImagePickerController?
    
    required init(viewController: ProfileController) {
        self.viewController = viewController
    }
    
    // MARK:- ProfileRouterProtocol
    
    func showImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = viewController
        viewController?.present(imagePicker!, animated: true)
    }
    
    func dismissImagePicker() {
        imagePicker?.dismiss(animated: true)
    }
}
