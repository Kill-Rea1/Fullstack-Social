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
    
    func toPostCellType() -> PostCellType? {
        let username = NSAttributedString(string: user.fullName, attributes: [.font: UIFont.boldSystemFont(ofSize: 17)])
        guard let _imageUrl = URL(string: imageUrl) else { return nil}
        let postText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15)])
        return PostCellEntity(username: username, imageUrl: _imageUrl, postText: postText, postId: self.id)
    }
}
