//
//  CommentCellType.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 01.11.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol CommentCellType {
    var text: String! { get set }
    var fromNow: String! { get set }
    var username: String! { get set }
    var profileImageUrl: URL? { get set }
}

class CommentCellEntity: CommentCellType {
    var text: String!
    
    var fromNow: String!
    
    var username: String!
    
    var profileImageUrl: URL?
    
    init(text: String, fromNow: String, username: String, profileImageUrl: String?) {
        let _profileImageUrl = URL(string: profileImageUrl ?? "")
        self.text = text
        self.fromNow = "Posted " + fromNow
        self.username = username
        self.profileImageUrl = _profileImageUrl
    }
}
