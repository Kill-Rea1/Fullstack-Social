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
    var fromNow: NSAttributedString! { get set }
    var imageUrl: URL! { get set }
    var postText: NSAttributedString! { get set }
    var postId: String! { get set }
}

class PostCellEntity: PostCellType {
    var username: NSAttributedString!
    
    var profileImageUrl: URL?
    
    var fromNow: NSAttributedString!
    
    var imageUrl: URL!
    
    var postText: NSAttributedString!
    
    var postId: String!
    
    init(username: String, profileImageUrl: String?, fromNow: String, imageUrl: String, postText: String, postId: String) {
        let _username = NSAttributedString(string: username, attributes: [.font: UIFont.boldSystemFont(ofSize: 17)])
        let _postText = NSAttributedString(string: postText, attributes: [.font: UIFont.systemFont(ofSize: 15)])
        let _profileImageUrl = URL(string: profileImageUrl ?? "")
        let _imageUrl = URL(string: imageUrl)!
        let _fromNow = NSAttributedString(string: "Posted " + fromNow, attributes: [.foregroundColor: UIColor.darkGray])
        
        self.username = _username
        self.profileImageUrl = _profileImageUrl
        self.fromNow = _fromNow
        self.imageUrl = _imageUrl
        self.postText = _postText
        self.postId = postId
    }
}
