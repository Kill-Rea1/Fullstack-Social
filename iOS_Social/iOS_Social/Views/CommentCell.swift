//
//  CommentCell.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 01.11.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol CommentCellProtocol: class {
    var commentCellType: CommentCellType? { get set }
}

class CommentCell: UICollectionViewCell, CommentCellProtocol {
    weak var commentCellType: CommentCellType? {
        didSet {
            profileImageView.sd_setImage(with: commentCellType?.profileImageUrl)
            usernameLabel.attributedText = commentCellType?.username
            postedLabel.attributedText = commentCellType?.fromNow
            commentTextLabel.attributedText = commentCellType?.text
        }
    }
    
    // MARK:- UI Elements
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "user"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.widthAnchor.constraint(equalToConstant: 40).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 40).isActive = true
        iv.layer.cornerRadius = 20
        iv.layer.borderWidth = 1
        return iv
    }()
    
    private let usernameLabel = UILabel()
    private let postedLabel = UILabel()
    private let commentTextLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commentTextLabel.numberOfLines = 0
        stack(hstack(profileImageView,
                     stack(usernameLabel, postedLabel),
                     UIView(), spacing: 16, alignment: .center),
              commentTextLabel,
              spacing: 16).withMargins(.init(top: 16, left: 16, bottom: 16, right: 16))
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
