//
//  SearchRouter.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 29.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol SearchRouterProtocol {
    func showProfile(with id: String)
}

class SearchRouter: SearchRouterProtocol {
    weak var viewController: SearchController?
    
    required init(viewController: SearchController) {
        self.viewController = viewController
    }
    
    func showProfile(with id: String) {
        let vc = ProfileController(userId: id)
        vc.delegate = viewController?.presenter as? ProfileModuleDelegate
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
