//
//  HomeController.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 27.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import WebKit

protocol HomeViewProtocol: class {
    func presentWebView(with html: String)
}

class HomeController: UITableViewController, HomeViewProtocol {
    
    var presenter: HomePresenterProtocol!
    let configurator: HomeConfiguratorProtocol = HomeConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(white: 0.95, alpha: 1)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Fetch posts", style: .plain, target: self, action: #selector(handleFetchPosts))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log in", style: .plain, target: self, action: #selector(handleLogIn))
        
        configurator.configure(with: self)
    }
    
    @objc
    fileprivate func handleFetchPosts() {
        presenter.fetchPostsTapped()
    }
    
    @objc
    fileprivate func handleLogIn() {
        presenter.logInTapped()
    }
    
    func presentWebView(with html: String) {
        let vc = UIViewController()
        let webView = WKWebView()
        webView.loadHTMLString(html, baseURL: nil)
        vc.view.addSubview(webView)
        webView.fillSuperview()
        self.present(vc, animated: true)
    }
}
