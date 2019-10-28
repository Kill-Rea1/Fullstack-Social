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
        let iv = UIImageView(image: nil)
        iv.contentMode = .scaleAspectFill
        iv.heightAnchor.constraint(equalTo: iv.widthAnchor).isActive = true
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
        let username = UIStackView(arrangedSubviews: [usernameLabel])
        username.axis = .vertical
        username.isLayoutMarginsRelativeArrangement = true
        username.layoutMargins.left = 16
        
        let postText = UIStackView(arrangedSubviews: [postTextLabel])
        postText.axis = .vertical
        postText.isLayoutMarginsRelativeArrangement = true
        postText.layoutMargins.left = 16
        postText.layoutMargins.right = 16
        
        let overallStackView = UIStackView(arrangedSubviews: [
            username,
            postImageView,
            postText
        ])
        overallStackView.axis = .vertical
        overallStackView.spacing = 16
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 16, left: 0, bottom: 16, right: 0)
        addSubview(overallStackView)
        overallStackView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
