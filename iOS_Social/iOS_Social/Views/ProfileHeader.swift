//
//  ProfileHeader.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 29.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol ProfileHeaderDelegate: class {
    func didFollowButtonTapped()
    func changeAvatar()
}

protocol ProfileHeaderProtocol: class {
    var delegate: ProfileHeaderDelegate? { get set }
    var profileHeaderType: ProfileHeaderType? { get set }
}

class ProfileHeader: UICollectionReusableView, ProfileHeaderProtocol {
    
    weak var delegate: ProfileHeaderDelegate?
    
    weak var profileHeaderType: ProfileHeaderType? {
        didSet {
            usernameLabel.attributedText = profileHeaderType?.username
            bioLabel.numberOfLines = 0
            bioLabel.attributedText = profileHeaderType?.bio
            if profileHeaderType?.isEditable ?? false {
                followButton.removeFromSuperview()
                profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEditProfile)))
            } else {
                followButton.setTitle((profileHeaderType?.isFollowing ?? false ? "Unfollow" : "Follow") , for: .normal)
                followButton.setTitleColor((profileHeaderType?.isFollowing ?? false ? .white : .black), for: .normal)
                followButton.backgroundColor = profileHeaderType?.isFollowing ?? false ? .black : .white
                editProfileButton.removeFromSuperview()
            }
            if profileHeaderType?.profileImageUrl != nil {
                profileImageView.sd_setImage(with: profileHeaderType?.profileImageUrl)
            }
            postsCountLabel.attributedText = profileHeaderType?.numberOfPosts
            followersCountLabel.attributedText = profileHeaderType?.numberOfFollowers
            followingCountLabel.attributedText = profileHeaderType?.numberOfFollowing
        }
    }
    
    // MARK:- UI Elements
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "user"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.widthAnchor.constraint(equalToConstant: 80).isActive = true
        iv.heightAnchor.constraint(equalTo: iv.widthAnchor).isActive = true
        iv.layer.cornerRadius = 40
        iv.isUserInteractionEnabled = true
        iv.layer.borderWidth = 1
        return iv
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        return button
    }()
    
    private lazy var editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1.0)
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(handleEditProfile), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.layer.cornerRadius = 15
        return button
    }()
    
    private let postsCountLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    private let postsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.text = "posts"
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    private let followersCountLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    private let followersLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.text = "followers"
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    private let followingCountLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.text = "following"
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    private let usernameLabel = UILabel()
    private let bioLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        stack(
            profileImageView,
            followButton,
            editProfileButton,
            hstack(stack(postsCountLabel, postsLabel),
                   stack(followersCountLabel, followersLabel),
                   stack(followingCountLabel, followingLabel),
                   spacing: 16, alignment: .center),
            usernameLabel,
            bioLabel,
            spacing: 12,
            alignment: .center
        ).withMargins(.init(top: 14, left: 14, bottom: 14, right: 14))
        
        separatorView()
    }
    
    private func separatorView() {
        let separatorView = UIView()
        addSubview(separatorView)
        separatorView.backgroundColor = UIColor(white: 0.6, alpha: 0.5)
        separatorView.addConstraints(leading: leadingAnchor, top: nil, trailing: trailingAnchor, bottom: bottomAnchor, size: .init(width: 0, height: 0.5))
    }
    
    @objc
    private func handleFollow() {
        delegate?.didFollowButtonTapped()
    }
    
    @objc
    private func handleEditProfile() {
        delegate?.changeAvatar()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
