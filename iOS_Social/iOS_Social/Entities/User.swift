//
//  User.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 28.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

struct User: Decodable {
    let id: String
    let fullName: String
    var bio: String?
    var imageUrl: String?
    let emailAddress: String
    var posts: [Post]?
    var following: [User]?
    var followers: [User]?
    var isFollowing: Bool?
    var isEditable: Bool?
    
    func toSearchType() -> SearchCellType {
        return SearchCellEntity(username: fullName, userId: id, isFollowing: isFollowing ?? false)
    }
    
    func toProfileHeader() -> ProfileHeaderType? {
        return ProfileHeaderEntity(username: fullName, bio: bio ?? "", numberOfPosts: posts?.count ?? 0, numberOfFollowing: following?.count ?? 0, numberOfFollowers: followers?.count ?? 0, isFollowing: isFollowing ?? false, isEditable: isEditable!, profileImageUrl: imageUrl)
    }
}
