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
    func updateView()
    func registerCell(with cellReuseIdentifier: String)
}

class HomeController: UITableViewController, HomeViewProtocol {
    
    fileprivate let cellId = "postCellId"
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
        tableView.register(PostCell.self, forCellReuseIdentifier: cellId)
        configurator.configure(with: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PostCell(style: .subtitle, reuseIdentifier: cellId)
        cell.postCellType = presenter.cellType(for: indexPath)
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
    
    // MARK:- HomeViewProtocol
    
    func updateView() {
        tableView.reloadData()
    }
    
    func registerCell(with cellReuseIdentifier: String) {
    }
}

extension HomeController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK:- ImagePickerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        presenter.didCancelImagePicker()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        presenter.didSelectImage(with: info)
    }
}
