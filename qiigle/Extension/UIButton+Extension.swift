//
//  UIButton+Extension.swift
//  OnaChat
//
//  Created by 島田智貴 on 2019/05/10.
//  Copyright © 2019 Tomozip. All rights reserved.
//

import UIKit
import SnapKit

extension UIButton {

    func setTitle(isBold: Bool = true, color: UIColor, fontSize: CGFloat, text: String) {
        let label = UILabel().then {
            $0.apply(isBold: isBold, size: fontSize, color: color)
            $0.text = text
        }

        addSubview(label)

        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
