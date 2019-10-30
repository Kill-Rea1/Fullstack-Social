//
//  PostCellType.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 28.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol PostCellType: class {
    var username: NSAttributedString! { get set }
    var profileImageUrl: URL? { get set }
    var imageUrl: URL! { get set }
    var postText: NSAttributedString! { get set }
    var postId: String! { get set }
}

class PostCellEntity: PostCellType {
    var username: NSAttributedString!
    
    var profileImageUrl: URL?
    
    var imageUrl: URL!
    
    var postText: NSAttributedString!
    
    var postId: String!
    
    init(username: NSAttributedString, profileImageUrl: URL?, imageUrl: URL, postText: NSAttributedString, postId: String) {
        self.username = username
        self.profileImageUrl = profileImageUrl
        self.imageUrl = imageUrl
        self.postText = postText
        self.postId = postId
    }
}
