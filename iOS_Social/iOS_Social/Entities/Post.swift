//
//  Post.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 28.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import UIKit

struct Post: Decodable {
    let id: String
    let text: String
    let imageUrl: String
    let createdAt: Int
    let user: User
    let fromNow: String
    var comments: [Comment]?
    var hasLiked: Bool?
    var numLikes: Int
    
    func toPostCellType() -> PostCellType? {
        return PostCellEntity(username: user.fullName, profileImageUrl: user.imageUrl, fromNow: fromNow, imageUrl: imageUrl, postText: text, postId: self.id, hasLiked: hasLiked ?? false, numLikes: numLikes)
    }
}
