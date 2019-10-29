//
//  PostCell.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 28.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol PostCellDelegate: class {
    func handleOptions(with id: String)
}

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
            postId = postCellType?.postId
        }
    }
    
    var postId: String!
    
    let usernameLabel = UILabel()
    
    let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalTo: iv.widthAnchor).isActive = true
        return iv
    }()
    
    let postTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "post_options"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleOptions), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 34).isActive = true
        return button
    }()
    
    weak var delegate: PostCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    @objc
    fileprivate func handleOptions() {
        guard let postId = postId else { return }
        delegate?.handleOptions(with: postId)
    }
    
    fileprivate func setupViews() {
        stack(hstack(usernameLabel,
                     UIView(),
                     optionsButton)
                    .padLeft(16).padRight(16),
              postImageView,
              stack(postTextLabel).padLeft(16).padRight(16),
              spacing: 16).withMargins(.init(top: 16, left: 0, bottom: 16, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
