//
//  UIViewExtensions.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 27.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

extension UIView {
    func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let parentLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: parentLeadingAnchor).isActive = true
        }
        
        if let parentTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: parentTopAnchor).isActive = true
        }
        
        if let parentTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: parentTrailingAnchor).isActive = true
        }
        
        if let parentBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: parentBottomAnchor).isActive = true
        }
    }
    
    func addConstraints(leading: NSLayoutXAxisAnchor?, top: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func centerInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let centerX = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        
        if let centerY = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }
}

class SpacerView: UIView {
    let size: CGFloat
    
    init(size: CGFloat) {
        self.size = size
        super.init(frame: .zero)
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: size, height: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
