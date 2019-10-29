//
//  SearchRouter.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 29.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol SearchRouterProtocol {
    
}

class SearchRouter: SearchRouterProtocol {
    weak var viewController: SearchController?
    
    required init(viewController: SearchController) {
        self.viewController = viewController
    }
}
