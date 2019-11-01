//
//  UserCellType.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 02.11.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol UserCellType: class {
    var profileImageUrl: URL? { get set }
    var username: String! { get set }
}

class UserCellEntity: UserCellType {
    var profileImageUrl: URL?
    
    var username: String!
    
    init(username: String, profileImageUrl: String) {
        let _profileImageUrl = URL(string: profileImageUrl)
        
        self.profileImageUrl = _profileImageUrl
        self.username = username
    }
}
