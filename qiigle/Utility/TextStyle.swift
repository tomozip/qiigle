//
//  TextStyle.swift
//  qiigle
//
//  Created by 島田智貴 on 2019/07/13.
//  Copyright © 2019 Tomozip. All rights reserved.
//

import UIKit

enum TextStyle: String {
    case notoSansMedium = "NotoSansCJKjp-Medium"
    case notoSansBold = "NotoSansCJKjp-Bold"
    case notoSansBlack = "NotoSansCJKjp-Black"
    case kollektifRegular = "Kollektif"
    case kollektifBold = "Kollektif-Bold"
}

extension UILabel {
    func apply(style: TextStyle, size: CGFloat, color: UIColor) {
        font = UIFont(name: style.rawValue, size: size)
        textColor = color
    }

    func apply(isBold: Bool = false, size: CGFloat, color: UIColor) {
        if isBold {
            font = UIFont.boldSystemFont(ofSize: size)
        }
        else {
            font = UIFont.systemFont(ofSize: size)
        }
        textColor = color
    }
}

