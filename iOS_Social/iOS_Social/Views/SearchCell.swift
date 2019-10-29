//
//  SearchCell.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 29.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol SearchCellDelegate: class {
    func didFollow(withID id: String)
}

protocol SearchCellProtocol: class {
    var searchCellType: SearchCellType? { get set }
    var delegate: SearchCellDelegate? { get set }
}

class SearchCell: UICollectionViewCell, SearchCellProtocol {
    
    var searchCellType: SearchCellType? {
        didSet {
            nameLabel.attributedText = searchCellType?.username
            userId = searchCellType?.userId
            followButton.setTitle(searchCellType?.buttonTitle, for: .normal)
            followButton.setTitleColor(searchCellType?.buttonTextColor, for: .normal)
            followButton.backgroundColor = searchCellType?.buttonColor
        }
    }
    
    var userId: String?
    
    weak var delegate: SearchCellDelegate?
    
    // MARK:- UI Elements
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "UserName"
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Follow", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 17
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 34).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
        return button
    }()
    
    @objc
    private func handleFollow() {
        guard let userId = userId else { return }
        delegate?.didFollow(withID: userId)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        hstack(nameLabel,
               UIView(),
               followButton,
               alignment: .center)
            .padLeft(24).padRight(24)
        separatorView()
    }
    
    private func separatorView() {
        let separatorView = UIView()
        addSubview(separatorView)
        separatorView.backgroundColor = UIColor(white: 0.6, alpha: 0.5)
        separatorView.addConstraints(leading: nameLabel.leadingAnchor, top: nil, trailing: trailingAnchor, bottom: bottomAnchor, size: .init(width: 0, height: 0.5))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
