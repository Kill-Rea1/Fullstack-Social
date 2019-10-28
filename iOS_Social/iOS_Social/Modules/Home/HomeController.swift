//
//  HomeController.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 27.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import WebKit
import SDWebImage

protocol HomeViewProtocol: class {
    func presentWebView(with html: String)
    func updateView()
}

class HomeController: UITableViewController, HomeViewProtocol {
    
    var presenter: HomePresenterProtocol!
    let configurator: HomeConfiguratorProtocol = HomeConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(white: 0.95, alpha: 1)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Fetch posts", style: .plain, target: self, action: #selector(handleFetchPosts)),
            UIBarButtonItem(title: "Create post", style: .plain, target: self, action: #selector(handleCreatePost))
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log in", style: .plain, target: self, action: #selector(handleLogIn))
        
        configurator.configure(with: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.attributedText = presenter.cellAuthor(for: indexPath)
        cell.textLabel?.font = .boldSystemFont(ofSize: 14)
        cell.detailTextLabel?.attributedText = presenter.cellText(for: indexPath)
        cell.detailTextLabel?.numberOfLines = 0
        cell.imageView?.sd_setImage(with: URL(string: presenter.cellImage(for: indexPath)))
        return cell
    }
    
    @objc
    fileprivate func handleFetchPosts() {
        presenter.fetchPostsTapped()
    }
    
    @objc
    fileprivate func handleCreatePost() {
        presenter.createPostsTapped()
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
    
    func updateView() {
        tableView.reloadData()
    }
}

extension HomeController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        presenter.didCancelImagePicker()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        presenter.didSelectImage(with: info)
    }
}
