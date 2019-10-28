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
    var imageUrl: URL! { get set }
    var postText: NSAttributedString! { get set }
}

class PostCellEntity: PostCellType {
    var username: NSAttributedString!
    
    var imageUrl: URL!
    
    var postText: NSAttributedString!
    
    init(username: NSAttributedString, imageUrl: URL, postText: NSAttributedString) {
        self.username = username
        self.imageUrl = imageUrl
        self.postText = postText
    }
}
