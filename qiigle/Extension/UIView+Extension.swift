//
//  UIView+Extension.swift
//  OnaChat
//
//  Created by 島田智貴 on 2019/05/09.
//  Copyright © 2019 Tomozip. All rights reserved.
//

import UIKit

extension UIView {

    func shadow(x: CGFloat = 0, y: CGFloat = 4, blur: CGFloat = 8, opacity: Float = 0.2) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = blur
        layer.shadowOpacity = opacity
    }
}
