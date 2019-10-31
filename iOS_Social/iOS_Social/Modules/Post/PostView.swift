//
//  PostController.swift
//  Post
//
//  Created by Kirill Ivanov on 01.11.2019.
//

import Foundation
import UIKit

protocol PostViewProtocol: class {
    
}

class PostController: UIViewController, PostViewProtocol {

    var presenter: PostPresenterProtocol!
    let configurator: PostConfiguratorProtocol = PostConfigurator()

    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        
    }
}
