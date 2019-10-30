//
//  MainTabBarController.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 30.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            createNavController(viewController: HomeController(), tabBarImage: #imageLiteral(resourceName: "home")),
            createNavController(viewController: UIViewController(), tabBarImage: #imageLiteral(resourceName: "plus")),
            createNavController(viewController: ProfileController(userId: ""), tabBarImage: #imageLiteral(resourceName: "user"))
        ]
        tabBar.tintColor = .black
    }
    
    private func createNavController(viewController: UIViewController, tabBarImage: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = tabBarImage
        return navController
    }
}
