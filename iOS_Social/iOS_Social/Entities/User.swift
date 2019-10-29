//
//  User.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 28.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

struct User: Decodable {
    let id: String
    let fullName: String
    let emailAddress: String
    var isFollowing: Bool?
    
    func toSearchType() -> SearchCellType {
        let username = NSAttributedString(string: fullName, attributes: [.font: UIFont.boldSystemFont(ofSize: 17)])
        return SearchCellEntity(username: username, userId: id, isFollowing: isFollowing ?? false)
    }
}
