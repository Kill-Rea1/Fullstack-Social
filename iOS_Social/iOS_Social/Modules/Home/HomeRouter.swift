//
//  HomeRouter.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 27.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol HomeRouterProtocol: class {
    func showLoginScreen()
    func showImagePicker()
    func showNewPostScreen(with info: Any, delegate: NewPostModuleDelegate)
    func dismissImagePicker()
    func showSearch()
    func showComments(postId: String)
    func showLikes(postId: String)
}

class HomeRouter: HomeRouterProtocol {
    
    weak var viewController: HomeController?
    
    var imagePicker: UIImagePickerController?
    
    required init(viewController: HomeController) {
        self.viewController = viewController
    }
    
    // MARK:- HomeRouterProtocol
    
    func showLoginScreen() {
        let navController = UINavigationController(rootViewController: LoginController())
        viewController?.present(navController, animated: true)
    }
    
    func showImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = viewController
        viewController?.present(imagePicker!, animated: true)
    }
    
    func showNewPostScreen(with info: Any, delegate: NewPostModuleDelegate) {
        guard let info = info as? [UIImagePickerController.InfoKey: Any], let image = info[.originalImage] as? UIImage else { return }
        imagePicker?.dismiss(animated: true)
        let newPostController = NewPostController(selectedImage: image, delegate: delegate)
        viewController?.present(newPostController, animated: true)
    }
    
    func dismissImagePicker() {
        imagePicker?.dismiss(animated: true)
    }
    
    func showSearch() {
        let navController = UINavigationController(rootViewController: SearchController())
        viewController?.present(navController, animated: true)
    }
    
    func showComments(postId: String) {
        let postController = PostController(postId: postId)
        viewController?.navigationController?.pushViewController(postController, animated: true)
    }
    
    func showLikes(postId: String) {
        let likesController = LikesController(postId: postId)
        viewController?.navigationController?.pushViewController(likesController, animated: true)
    }
}
