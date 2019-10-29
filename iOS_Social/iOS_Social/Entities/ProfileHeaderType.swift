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
    var numberOfPosts: Int! { get set }
    var numberOfFollowing: Int! { get set }
    var numberOfFollowers: Int! { get set }
    var isFollowing: Bool! { get set }
}

class ProfileHeaderEntity: ProfileHeaderType {
    var username: NSAttributedString!
    
    var numberOfPosts: Int!
    
    var numberOfFollowing: Int!
    
    var numberOfFollowers: Int!
    
    var isFollowing: Bool!
    
    init(username: NSAttributedString, numberOfPosts: Int, numberOfFollowing: Int, numberOfFollowers: Int, isFollowing: Bool) {
        self.username = username
        self.numberOfPosts = numberOfPosts
        self.numberOfFollowing = numberOfFollowing
        self.numberOfFollowers = numberOfFollowers
        self.isFollowing = isFollowing
    }
}
