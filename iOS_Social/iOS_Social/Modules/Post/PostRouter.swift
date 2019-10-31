//
//  PostRouter.swift
//  Post
//
//  Created by Kirill Ivanov on 01.11.2019.
//

import Foundation
import UIKit

protocol PostRouterProtocol: class {
    
}

class PostRouter: PostRouterProtocol {

    weak var viewController: PostViewProtocol?
    
    required init(viewController: PostController) {
        self.viewController = viewController
    }
}
