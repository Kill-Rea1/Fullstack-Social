//
//  NewPostController.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 28.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol NewPostViewProtocol: class {
    func changePlaceholderHidden(to isHidden: Bool)
    func getImageData() -> Data
    func HUDProgress(progress: Float, text: String)
    func showHUD(with text: String)
    func hideHUD()
}

class NewPostController: UIViewController, NewPostViewProtocol {
    
    let selectedImage: UIImage
    weak var delegate: NewPostModuleDelegate?
    
    init(selectedImage: UIImage, delegate: NewPostModuleDelegate) {
        self.selectedImage = selectedImage
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        imageView.image = selectedImage
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK:- UI Elements
    
    var hud: JGProgressHUD!
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 300).isActive = true
        return iv
    }()
    
    lazy var postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.backgroundColor = #colorLiteral(red: 0.1127949134, green: 0.5649430156, blue: 0.9994879365, alpha: 1)
        button.layer.cornerRadius = 5
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handlePost), for: .touchUpInside)
        return button
    }()
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your post body text..."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var postBodyTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 14)
        tv.backgroundColor = .clear
        tv.delegate = self
        return tv
    }()
    
    let configurator: NewPostConfiguratorProtocol = NewPostConfigurator()
    var presenter: NewPostPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configurator.configure(with: self)
        setupViews()
    }
    
    fileprivate func setupViews() {
        postButton.layer.cornerRadius = 5
        
        view.stack(imageView,
                   view.stack(postButton,
                              placeholderLabel,
                              spacing: 16).padLeft(16).padRight(16),
                   UIView(),
                   spacing: 16)
        view.addSubview(postBodyTextView)
        postBodyTextView.backgroundColor = .clear
        postBodyTextView.delegate = self
        postBodyTextView.addConstraints(leading: placeholderLabel.leadingAnchor, top: placeholderLabel.bottomAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, padding: .init(top: -25, left: -6, bottom: 0, right: 16))
    }
    
    
    @objc
    fileprivate func handlePost() {
        presenter.createPost()
    }
    
    // MARK:- NewPostViewProtocol
    
    func changePlaceholderHidden(to isHidden: Bool) {
        placeholderLabel.alpha = isHidden ? 1 : 0
    }
    
    func getImageData() -> Data {
        return imageView.image?.jpegData(compressionQuality: 0.5) ?? Data()
    }
    
    func showHUD(with text: String) {
        hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = text
        hud.indicatorView = JGProgressHUDRingIndicatorView()
        hud.show(in: view)
    }
    
    func HUDProgress(progress: Float, text: String) {
        hud.progress = progress
        hud.textLabel.text = text
    }
    
    func hideHUD() {
        hud.dismiss()
    }
}

extension NewPostController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        presenter.textViewDidChange(with: textView.text)
    }
}
