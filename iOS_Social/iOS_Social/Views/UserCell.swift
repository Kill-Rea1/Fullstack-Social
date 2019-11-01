//
//  UserCell.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 02.11.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol UserCellProtocol: class {
    var userCellType: UserCellType? { get set }
}

class UserCell: UICollectionViewCell, UserCellProtocol {
    weak var userCellType: UserCellType? {
        didSet {
            profileImageView.sd_setImage(with: userCellType?.profileImageUrl)
            usernameLabel.text = userCellType?.username
        }
    }
    
    // MARK:- UI Elements
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "user"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.widthAnchor.constraint(equalToConstant: 48).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 48).isActive = true
        iv.layer.cornerRadius = 24
        iv.layer.borderWidth = 1
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        hstack(profileImageView,
               usernameLabel,
               spacing: 16, alignment: .center).withMargins(.init(top: 16, left: 16, bottom: 16, right: 16))
        separatorView()
    }
    
    private func separatorView() {
        let separatorView = UIView()
        addSubview(separatorView)
        separatorView.backgroundColor = UIColor(white: 0.6, alpha: 0.5)
        separatorView.addConstraints(leading: profileImageView.leadingAnchor, top: nil, trailing: trailingAnchor, bottom: bottomAnchor, size: .init(width: 0, height: 0.5))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
