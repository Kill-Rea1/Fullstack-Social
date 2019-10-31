//
//  CommentCell.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 01.11.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol CommentCellProtocol: class {
    var commentCellType: CommentCellType? { get set }
}

class CommentCell: UICollectionViewCell, CommentCellProtocol {
    var commentCellType: CommentCellType? {
        didSet {
            
        }
    }
    
    // MARK:- UI Elements
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
