//
//  ProfileHeader.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 29.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol ProfileHeaderType: class {
    var username: NSAttributedString! { get set }
    var bio: NSAttributedString! { get set }
    var numberOfPosts: NSAttributedString! { get set }
    var numberOfFollowing: NSAttributedString! { get set }
    var numberOfFollowers: NSAttributedString! { get set }
    var isFollowing: Bool! { get set }
    var isEditable: Bool! { get set }
    var profileImageUrl: URL? { get set }
}

class ProfileHeaderEntity: ProfileHeaderType {
    var username: NSAttributedString!
    var bio: NSAttributedString!
    var numberOfPosts: NSAttributedString!
    var numberOfFollowing: NSAttributedString!
    var numberOfFollowers: NSAttributedString!
    var isFollowing: Bool!
    var isEditable: Bool!
    var profileImageUrl: URL?
    
    init(username: String, bio: String, numberOfPosts: Int, numberOfFollowing: Int, numberOfFollowers: Int, isFollowing: Bool, isEditable: Bool, profileImageUrl: String?) {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let _username = NSAttributedString(string: username, attributes: [.font: UIFont.boldSystemFont(ofSize: 17), .paragraphStyle: style])
        let _bio = NSAttributedString(string: bio, attributes: [.font: UIFont.systemFont(ofSize: 13), .foregroundColor: UIColor.darkGray, .paragraphStyle: style])
        let _profileImageUrl = URL(string: profileImageUrl ?? "")
        let attr = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.paragraphStyle: style]
        let _numberOfPosts = NSAttributedString(string: "\(numberOfPosts)", attributes: attr)
        let _numberOfFollowing = NSAttributedString(string: "\(numberOfFollowing)", attributes: attr)
        let _numberOfFollowers = NSAttributedString(string: "\(numberOfFollowers)", attributes: attr)
        
        self.username = _username
        self.bio = _bio
        self.numberOfPosts = _numberOfPosts
        self.numberOfFollowing = _numberOfFollowing
        self.numberOfFollowers = _numberOfFollowers
        self.isFollowing = isFollowing
        self.isEditable = isEditable
        self.profileImageUrl = _profileImageUrl
    }
}
