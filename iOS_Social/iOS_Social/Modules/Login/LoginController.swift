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
    func showHUD(with text: String)
    func hideHUD()
    func showErrorLabel()
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
    
    private var overralStackView = UIStackView()
    
    var presenter: LoginPresenterProtocol!
    let configurator: LoginConfiguratorProtocol = LoginConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .init(white: 0.95, alpha: 1)
        navigationController?.navigationBar.isHidden = true
        configurator.configure(with: self)
        setupViews()
        addNotifications()
        createToolBar()
    }
    
    private func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleShowKeyboard(notification: Notification) {
        
        guard let userInfo = notification.userInfo else { return }
        guard let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - overralStackView.frame.origin.y - overralStackView.frame.height + 80
        let difference = keyboardFrame.height - bottomSpace
        if difference > 0 {
            view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
        }
    }
    
    @objc fileprivate func handleHideKeyboard() {
        view.transform = .identity
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
        
        overralStackView = UIStackView(arrangedSubviews: [
            stackView,
            SpacerView(size: 12),
            emailTextField,
            passwordTextField,
            loginButton,
            errorLabel,
            goToRegisterButton,
            SpacerView(size: 80)
        ])
        
        overralStackView.spacing = 16
        overralStackView.axis = .vertical
        overralStackView.isLayoutMarginsRelativeArrangement = true
        overralStackView.layoutMargins = .init(top: 48, left: 32, bottom: 0, right: 32)
        overralStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(overralStackView)
        overralStackView.centerInSuperview()
        overralStackView.addConstraints(leading: view.leadingAnchor, top: nil, trailing: view.trailingAnchor, bottom: nil)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc
    private func handleTap() {
        view.endEditing(true)
    }
    
    fileprivate func createToolBar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleTap))
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        doneButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        toolbar.setItems([flex, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        toolbar.backgroundColor = #colorLiteral(red: 0.8138477206, green: 0.8237602115, blue: 0.8536676764, alpha: 1)
        emailTextField.inputAccessoryView = toolbar
        passwordTextField.inputAccessoryView = toolbar
    }
    
    @objc
    fileprivate func handleLogIn() {
        presenter.loginButtonTapped()
    }
    
    @objc
    fileprivate func handleToRegister() {
        presenter.toRegisterButtonTapped()
    }
    
    @objc
    fileprivate func handleTextChanged(sender: UITextField) {
        switch sender {
        case emailTextField:
            presenter.emailChanged(to: sender.text ?? "")
        default:
            presenter.passwordChanged(to: sender.text ?? "")
        }
    }
    
    // MARK:- LoginViewProtocol
    
    func showHUD(with text: String) {
        hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = text
        hud.show(in: view)
    }
    
    func hideHUD() {
        hud.dismiss()
    }
    
    func showErrorLabel() {
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.errorLabel.isHidden = false
        }) { (_) in
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.errorLabel.isHidden = true
            })
        }
    }
}
