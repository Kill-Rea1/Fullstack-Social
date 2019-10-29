//
//  ProfileHeader.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 29.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol ProfileHeaderDelegate: class {
    func didFollow()
}

protocol ProfileHeaderProtocol: class {
    var delegate: ProfileHeaderDelegate? { get set }
    var profileHeaderType: ProfileHeaderType? { get set }
}

class ProfileHeader: UICollectionReusableView, ProfileHeaderProtocol {
    
    weak var delegate: ProfileHeaderDelegate?
    
    weak var profileHeaderType: ProfileHeaderType? {
        didSet {
            followButton.setTitle((profileHeaderType?.isFollowing ?? false ? "Unfollow" : "Follow") , for: .normal)
            followButton.setTitleColor((profileHeaderType?.isFollowing ?? false ? .white : .black), for: .normal)
            followButton.backgroundColor = profileHeaderType?.isFollowing ?? false ? .black : .white
            usernameLabel.attributedText = profileHeaderType?.username
            postsCountLabel.text = "\(profileHeaderType?.numberOfPosts ?? 0)"
            followersCountLabel.text = "\(profileHeaderType?.numberOfFollowers ?? 0)"
            followingCountLabel.text = "\(profileHeaderType?.numberOfFollowing ?? 0)"
        }
    }
    
    // MARK:- UI Elements
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "user"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
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
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "Here's an interesting piece of bio that will definitely capture your attention and all the fans around the world"
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        stack(
            profileImageView,
            followButton,
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
        delegate?.didFollow()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
