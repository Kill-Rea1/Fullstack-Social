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
    var isFollowing: Bool! { get set }
    var buttonTitle: String! { get }
    var buttonTextColor: UIColor! { get }
    var buttonColor: UIColor! { get }
}

class SearchCellEntity: SearchCellType {
    
    var username: NSAttributedString!
    var userId: String!
    var isFollowing: Bool! = false
    
    var buttonTitle: String! {
        return isFollowing ? "Unfollow" : "Follow"
    }
    
    var buttonTextColor: UIColor! {
        return isFollowing ? UIColor.white : UIColor.black
    }
    
    var buttonColor: UIColor! {
        return isFollowing ? UIColor.black : UIColor.white
    }
    
    init(username: NSAttributedString, userId: String, isFollowing: Bool) {
        self.username = username
        self.userId = userId
        self.isFollowing = isFollowing
    }
}
