//
//  UserPostCell.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 29.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol PostCellDelegate: class {
    func didLikedPost(postId: String)
    func didCommentsTapped(postId: String)
    func didOptionsTapped(postId: String)
    func showLikesButtonTapped(postId: String)
}

protocol PostCellProtocol: class {
    var postCellType: PostCellType? { get set }
    var delegate: PostCellDelegate? { get set }
}

class PostCell: UICollectionViewCell, PostCellProtocol {
    
    weak var postCellType: PostCellType? {
        didSet {
            usernameLabel.attributedText = postCellType?.username
            if let url = postCellType?.profileImageUrl {
                profileImageView.sd_setImage(with: url)
            }
            postTextLabel.numberOfLines = 0
            postedLabel.attributedText = postCellType?.fromNow
            postImageView.sd_setImage(with: postCellType?.imageUrl)
            postTextLabel.attributedText = postCellType?.postText
            postId = postCellType?.postId
            if (postCellType?.hasLiked)! {
                likeButton.setImage(#imageLiteral(resourceName: "like-filled").withRenderingMode(.alwaysTemplate), for: .normal)
                likeButton.tintColor = .red
            } else {
                likeButton.setImage(#imageLiteral(resourceName: "like-outline"), for: .normal)
                likeButton.tintColor = .black
            }
            numLikesButton.setTitle("\(postCellType?.numLikes ?? 0) likes", for: .normal)
        }
    }
    
    var delegate: PostCellDelegate?
    
    var postId: String!
    
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
    private lazy var postImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.heightAnchor.constraint(equalToConstant: frame.width).isActive = true
        return iv
    }()
    private let postTextLabel = UILabel()
    private lazy var optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "post_options"), for: .normal)
        button.tintColor = .black
        button.widthAnchor.constraint(equalToConstant: 34).isActive = true
        button.addTarget(self, action: #selector(handleOptions), for: .touchUpInside)
        return button
    }()
    private lazy var likeButton = UIButton()
    private lazy var commentsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment-bubble"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleComments), for: .touchUpInside)
        return button
    }()
    private lazy var numLikesButton: UIButton = {
        let button = UIButton(type: .system)
//        button.setTitle("0 likes", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleShowLikes), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        stack(hstack(profileImageView,
                     stack(usernameLabel,
                           postedLabel),
                     UIView(),
                     optionButton, spacing: 16).padLeft(16).padRight(16),
              postImageView,
              stack(postTextLabel).padLeft(16).padRight(16),
              hstack(likeButton, commentsButton, UIView(), spacing: 16).padLeft(16),
              hstack(numLikesButton, UIView()).padLeft(16),
              spacing: 16).withMargins(.init(top: 16, left: 0, bottom: 16, right: 0))
        separatorView()
    }
    
    private func separatorView() {
        let separatorView = UIView()
        addSubview(separatorView)
        separatorView.backgroundColor = UIColor(white: 0.6, alpha: 0.5)
        separatorView.addConstraints(leading: profileImageView.leadingAnchor, top: nil, trailing: trailingAnchor, bottom: bottomAnchor, size: .init(width: 0, height: 0.5))
    }
    
    @objc
    private func handleOptions() {
        delegate?.didOptionsTapped(postId: postId)
    }
    
    @objc
    private func handleLike() {
        delegate?.didLikedPost(postId: postId)
    }
    
    @objc
    private func handleComments() {
        delegate?.didCommentsTapped(postId: postId)
    }
    
    @objc
    private func handleShowLikes() {
        delegate?.showLikesButtonTapped(postId: postId)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
