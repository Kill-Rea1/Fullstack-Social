//
//  PostCell.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 28.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol PostCellProtocol: class {
    var postCellType: PostCellType? { get set }
}

class PostCell: UITableViewCell, PostCellProtocol {
    
    // MARK:- UI Elements
    
    weak var postCellType: PostCellType? {
        didSet {
            usernameLabel.attributedText = postCellType?.username
            postImageView.sd_setImage(with: postCellType?.imageUrl)
            postTextLabel.attributedText = postCellType?.postText
        }
    }
    
    let usernameLabel = UILabel()
    
    let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 300).isActive = true
        return iv
    }()
    
    let postTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    fileprivate func setupViews() {
        stack(stack(usernameLabel).padLeft(16),
              postImageView,
              stack(postTextLabel).padLeft(16).padRight(16),
              spacing: 16).withMargins(.init(top: 16, left: 0, bottom: 16, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
