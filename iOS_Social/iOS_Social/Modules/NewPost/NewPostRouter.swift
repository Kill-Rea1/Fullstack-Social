//
//  NewPostRouter.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 28.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol NewPostRouterProtocol: class {
    func dismiss()
}

class NewPostRouter: NewPostRouterProtocol {
    weak var viewController: NewPostController?
    
    required init(viewController: NewPostController) {
        self.viewController = viewController
    }
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
