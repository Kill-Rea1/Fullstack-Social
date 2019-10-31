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
    func addResfreshControl()
    func endRefreshing()
    func fetchPosts()
}

class HomeController: BaseCollectionController, HomeViewProtocol, UICollectionViewDelegateFlowLayout {
    
    var presenter: HomePresenterProtocol!
    let configurator: HomeConfiguratorProtocol = HomeConfigurator()
    private let cellId = "postCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        collectionView.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(handleSearch))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log in", style: .plain, target: self, action: #selector(handleLogIn))
        collectionView.delaysContentTouches = false
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: cellId)
        presenter.configureView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostCellProtocol
        cell.postCellType = presenter.cellType(for: indexPath)
        cell.delegate = presenter as? PostCellDelegate
        return (cell as! UICollectionViewCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let dummyCell = PostCell(frame: .init(x: 0, y: 0, width: width, height: 1000))
        dummyCell.postCellType = presenter.cellType(for: indexPath)
        dummyCell.layoutIfNeeded()
        let size = dummyCell.systemLayoutSizeFitting(.init(width: width, height: 1000))
        let height = size.height
        return .init(width: width, height: height)
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
    
    @objc
    private func handleRefresh() {
        presenter.refresh()
    }
    
    // MARK:- HomeViewProtocol
    
    func updateView() {
        collectionView.reloadData()
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
        collectionView.deleteItems(at: [indexPath])
//        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func addResfreshControl() {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = rc
    }
    
    func endRefreshing() {
        collectionView.refreshControl?.endRefreshing()
    }
    
    func fetchPosts() {
        presenter.refresh()
    }
}

extension HomeController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK:- ImagePickerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        presenter.imagePickerDidCancel()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        presenter.didSelectImage(with: info)
    }
}
