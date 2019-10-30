//
//  BaseCollectionController.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 30.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class BaseCollectionController: UICollectionViewController {
    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
