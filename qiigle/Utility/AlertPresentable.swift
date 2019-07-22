//
//  AlertPresentable.swift
//  qiigle
//
//  Created by 島田智貴 on 2019/07/22.
//  Copyright © 2019 Tomozip. All rights reserved.
//

import UIKit
import UserNotifications

protocol AlertPresentable {
    func showAPIRetryAlert(comletion: @escaping () -> Void)
}

extension AlertPresentable where Self: UIViewController {
    func showAPIRetryAlert(comletion: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "通信エラー",
            message: "通信環境が不安定です。しばらく時間を置いて、再度お試しください。",
            preferredStyle: .alert
            ).then {
                $0.addAction(UIAlertAction(title: "リトライ", style: .default) { _ in
                    comletion()
                })
                $0.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        }
        present(alert, animated: true, completion: nil)
    }
}
