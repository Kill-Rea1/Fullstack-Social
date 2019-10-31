//
//  SearchCellType.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 29.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol SearchCellType {
    var username: NSAttributedString! { get set }
    var userId: String! { get set }
    var buttonTitle: String! { get }
    var buttonTextColor: UIColor! { get }
    var buttonColor: UIColor! { get }
}

class SearchCellEntity: SearchCellType {
    
    var username: NSAttributedString!
    var userId: String!
    var isFollowing = false
    
    var buttonTitle: String! {
        return isFollowing ? "Unfollow" : "Follow"
    }
    
    var buttonTextColor: UIColor! {
        return isFollowing ? UIColor.white : UIColor.black
    }
    
    var buttonColor: UIColor! {
        return isFollowing ? UIColor.black : UIColor.white
    }
    
    init(username: String, userId: String, isFollowing: Bool) {
        let _username = NSAttributedString(string: username, attributes: [.font: UIFont.boldSystemFont(ofSize: 17)])
        
        self.username = _username
        self.userId = userId
        self.isFollowing = isFollowing
    }
}
