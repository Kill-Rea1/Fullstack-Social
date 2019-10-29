//
//  User.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 28.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

struct User: Decodable {
    let id: String
    let fullName: String
    let emailAddress: String
}
