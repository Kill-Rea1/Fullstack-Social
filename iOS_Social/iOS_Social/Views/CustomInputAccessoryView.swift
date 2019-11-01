//
//  CustomInputAccessoryView.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 01.11.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol CustomInputAccessoryViewDelegate: class {
    func sendButtonTapped(with commentText: String)
}

class CustomInputAccessoryView: UIView {
    
    weak var delegate: CustomInputAccessoryViewDelegate?
    
    // MARK:- UI Elements
    
    private let commentTextView = UITextView()
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SEND", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter comment.."
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    @objc
    private func handleSend() {
        delegate?.sendButtonTapped(with: commentTextView.text)
        commentTextView.text = ""
        placeholderLabel.isHidden = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupShadow(opacity: 0.1, radius: 8, offset: .init(width: 0, height: -8), color: .lightGray)
        autoresizingMask = .flexibleHeight
        
        commentTextView.isScrollEnabled = false
        commentTextView.font = .systemFont(ofSize: 16)
        commentTextView.delegate = self
        
        hstack(commentTextView,
               sendButton,
               alignment: .center
            ).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
        
        addSubview(placeholderLabel)
        placeholderLabel.addConstraints(leading: leadingAnchor, top: nil, trailing: sendButton.leadingAnchor, bottom: nil, padding: .init(top: 0, left: 20, bottom: 0, right: 0))
        placeholderLabel.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
    }
    
    private func setupShadow(opacity: Float = 0, radius: CGFloat = 0, offset: CGSize = .zero, color: UIColor = .black) {
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension CustomInputAccessoryView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.text.count != 0
    }
}
