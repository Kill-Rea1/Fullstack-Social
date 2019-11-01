//
//  CommentCellType.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 01.11.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol CommentCellType: class {
    var text: NSAttributedString! { get set }
    var fromNow: NSAttributedString! { get set }
    var username: NSAttributedString! { get set }
    var profileImageUrl: URL? { get set }
}

class CommentCellEntity: CommentCellType {
    var text: NSAttributedString!
    
    var fromNow: NSAttributedString!
    
    var username: NSAttributedString!
    
    var profileImageUrl: URL?
    
    init(text: String, fromNow: String, username: String, profileImageUrl: String?) {
        let _profileImageUrl = URL(string: profileImageUrl ?? "")
        let _username = NSAttributedString(string: username, attributes: [.font: UIFont.boldSystemFont(ofSize: 17)])
        let _fromNow = NSAttributedString(string: "Posted " + fromNow, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.darkGray])
        let _text = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 14)])
        
        self.text = _text
        self.fromNow = _fromNow
        self.username = _username
        self.profileImageUrl = _profileImageUrl
    }
}
