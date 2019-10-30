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
    var isEditable: Bool? = false
    
    func toSearchType() -> SearchCellType {
        let username = NSAttributedString(string: fullName, attributes: [.font: UIFont.boldSystemFont(ofSize: 17)])
        return SearchCellEntity(username: username, userId: id, isFollowing: isFollowing ?? false)
    }
    
    func toProfileHeader() -> ProfileHeaderType? {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let username = NSAttributedString(string: fullName, attributes: [.font: UIFont.boldSystemFont(ofSize: 17), .paragraphStyle: style])
        let url = URL(string: imageUrl ?? "")
        return ProfileHeaderEntity(username: username, bio: bio ?? "", numberOfPosts: posts?.count ?? 0, numberOfFollowing: following?.count ?? 0, numberOfFollowers: followers?.count ?? 0, isFollowing: isFollowing ?? false, isEditable: isEditable!, profileImageUrl: url)
    }
}
