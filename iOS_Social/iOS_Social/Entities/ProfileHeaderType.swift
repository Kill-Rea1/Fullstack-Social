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
    var bio: String! { get set }
    var numberOfPosts: Int! { get set }
    var numberOfFollowing: Int! { get set }
    var numberOfFollowers: Int! { get set }
    var isFollowing: Bool! { get set }
    var isEditable: Bool! { get set }
    var profileImageUrl: URL? { get set }
}

class ProfileHeaderEntity: ProfileHeaderType {
    var username: NSAttributedString!
    var bio: String!
    var numberOfPosts: Int!
    var numberOfFollowing: Int!
    var numberOfFollowers: Int!
    var isFollowing: Bool!
    var isEditable: Bool!
    var profileImageUrl: URL?
    
    init(username: NSAttributedString, bio: String, numberOfPosts: Int, numberOfFollowing: Int, numberOfFollowers: Int, isFollowing: Bool, isEditable: Bool, profileImageUrl: URL? = nil) {
        self.username = username
        self.bio = bio
        self.numberOfPosts = numberOfPosts
        self.numberOfFollowing = numberOfFollowing
        self.numberOfFollowers = numberOfFollowers
        self.isFollowing = isFollowing
        self.isEditable = isEditable
        self.profileImageUrl = profileImageUrl
    }
}
