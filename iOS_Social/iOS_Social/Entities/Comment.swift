//
//  Comment.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 01.11.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

struct Comment: Decodable {
    let text: String
    let user: User
    let fromNow: String
    
    func toCommentType() -> CommentCellType {
        return CommentCellEntity(text: text, fromNow: fromNow, username: user.fullName, profileImageUrl: user.imageUrl)
    }
}
