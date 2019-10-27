//
//  LoginController.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 27.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol LoginViewProtocol: class {
    func showLoginHUD(with text: String)
    func hideLoginHUD()
}

class LoginController: UIViewController, LoginViewProtocol {
    
    // MARK:- UI Elements
    
    var hud: JGProgressHUD!
    
    let logoImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "startup"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "FullStack Social"
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = CustomTextField(padding: 24)
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.placeholder = "Email"
        tf.layer.cornerRadius = 25
        tf.keyboardType = .emailAddress
        tf.backgroundColor = .white
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        return tf
    }()
    
    lazy var passwordTextField: UITextField = {
        let tf = CustomTextField(padding: 24)
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.placeholder = "Password"
        tf.layer.cornerRadius = 25
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        return tf
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        button.layer.cornerRadius = 25
        return button
    }()
    
    let goToRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Need an account? Go to register.", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleToRegister), for: .touchUpInside)
        return button
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Your login credentials were incorrect, please try again."
        label.textColor = .red
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    var presenter: LoginPresenterProtocol!
    let configurator: LoginConfiguratorProtocol = LoginConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .init(white: 0.95, alpha: 1)
        navigationController?.navigationBar.isHidden = true
        configurator.configure(with: self)
        setupViews()
    }
    
    fileprivate func setupViews() {
        let logoStackView = UIStackView(arrangedSubviews: [
            logoImage, logoLabel
        ])
        logoStackView.spacing = 16
        logoStackView.alignment = .center
        let stackView = UIStackView(arrangedSubviews: [logoStackView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins.left = 16
        stackView.layoutMargins.right = 16
        
        let overrallStackView = UIStackView(arrangedSubviews: [
            stackView,
            SpacerView(size: 12),
            emailTextField,
            passwordTextField,
            loginButton,
            errorLabel,
            goToRegisterButton,
            SpacerView(size: 80)
        ])
        
        overrallStackView.spacing = 16
        overrallStackView.axis = .vertical
        overrallStackView.isLayoutMarginsRelativeArrangement = true
        overrallStackView.layoutMargins = .init(top: 48, left: 32, bottom: 0, right: 32)
        overrallStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(overrallStackView)
        overrallStackView.addConstraints(leading: view.leadingAnchor, top: view.topAnchor, trailing: view.trailingAnchor, bottom: nil)
    }
    
    
    @objc
    fileprivate func handleLogIn() {
        presenter.loginButtonTapped()
    }
    
    @objc
    fileprivate func handleToRegister() {}
    
    @objc
    fileprivate func handleTextChanged(sender: UITextField) {
        switch sender {
        case emailTextField:
            presenter.emailChanged(to: sender.text ?? "")
        default:
            presenter.passwordChanged(to: sender.text ?? "")
        }
    }
    
    
    func showLoginHUD(with text: String) {
        hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = text
        hud.show(in: view)
    }
    
    func hideLoginHUD() {
        hud.dismiss()
    }
}
