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
    func showAlertSheet()
    func deleteRow(from indexPath: IndexPath)
}

class HomeController: UITableViewController, HomeViewProtocol {
    
    var presenter: HomePresenterProtocol!
    let configurator: HomeConfiguratorProtocol = HomeConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        view.backgroundColor = .init(white: 0.95, alpha: 1)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(handleSearch)),
            UIBarButtonItem(title: "Create post", style: .plain, target: self, action: #selector(handleCreatePost))
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log in", style: .plain, target: self, action: #selector(handleLogIn))
        tableView.delaysContentTouches = false
        presenter.configureView()
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PostCell(style: .default, reuseIdentifier: "cellId")
        cell.postCellType = presenter.cellType(for: indexPath)
        cell.delegate = presenter as? PostCellDelegate
        return cell
    }
    
    @objc
    fileprivate func handleSearch() {
        presenter.searchTapped()
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
    
    func showAlertSheet() {
        let alertController = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            self.deletePost()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    fileprivate func deletePost() {
        presenter.deletePost()
    }
    
    func deleteRow(from indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .automatic)
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
