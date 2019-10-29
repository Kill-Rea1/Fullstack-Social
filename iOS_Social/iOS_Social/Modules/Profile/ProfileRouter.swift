//
//  ProfileRouter.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 29.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol ProfileRouterProtocol: class {
    
}

class ProfileRouter: ProfileRouterProtocol {
    weak var viewController: ProfileController?
    
    required init(viewController: ProfileController) {
        self.viewController = viewController
    }
}
