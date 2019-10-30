//
//  MainTabBarController.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 30.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

// MARK:- Turn it into VIPER later

extension MainTabBarController: UINavigationControllerDelegate, UIImagePickerControllerDelegate, NewPostModuleDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            dismiss(animated: true) {
                let newPostController = NewPostController(selectedImage: image, delegate: self)
                self.present(newPostController, animated: true)
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func didCreatePost() {
        homeController.fetchPosts()
        profileController.fetchUserProfile()
    }
}

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    fileprivate let homeController: HomeViewProtocol = HomeController()
    fileprivate let profileController: ProfileViewProtocol = ProfileController(userId: "")
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewControllers?.firstIndex(of: viewController) == 1 {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            present(imagePicker, animated: true)
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        let vc = UIViewController()
        vc.view.backgroundColor = .yellow
        viewControllers = [
            createNavController(viewController: homeController as! UIViewController, tabBarImage: #imageLiteral(resourceName: "home")),
            createNavController(viewController: vc, tabBarImage: #imageLiteral(resourceName: "plus")),
            createNavController(viewController: profileController as! UIViewController, tabBarImage: #imageLiteral(resourceName: "user"))
        ]
        tabBar.tintColor = .black
    }
    
    private func createNavController(viewController: UIViewController, tabBarImage: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = tabBarImage
        return navController
    }
}
