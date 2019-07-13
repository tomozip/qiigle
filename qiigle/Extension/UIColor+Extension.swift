//
//  UIColor+Extension.swift
//  OnaChat
//
//  Created by 島田智貴 on 2019/05/08.
//  Copyright © 2019 Tomozip. All rights reserved.
//

import UIKit

extension UIColor {
    /// hex: 6 charactors, alpha: 0 - 1.0
    /// e.g. hex: "FFFFFF", alpha: 0.5
    convenience init(hex: String, alpha: CGFloat) {
        guard hex.count == 6 else { fatalError("hex should be 6 charactors") }
        let hex = hex.map { String($0) }
        let red = CGFloat(Int(hex[0] + hex[1], radix: 16) ?? 0) / 255.0
        let green = CGFloat(Int(hex[2] + hex[3], radix: 16) ?? 0) / 255.0
        let blue = CGFloat(Int(hex[4] + hex[5], radix: 16) ?? 0) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: min(max(alpha, 0), 1))
    }

    convenience init(hex: String) {
        self.init(hex: hex, alpha: 1.0)
    }

    var translucent: UIColor {
        return withAlphaComponent(0.25)
    }
}
