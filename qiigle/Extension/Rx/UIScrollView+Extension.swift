//
//  UIScrollView+Extension.swift
//  qiigle
//
//  Created by 島田智貴 on 2019/07/14.
//  Copyright © 2019 Tomozip. All rights reserved.
//

import UIKit
import RxSwift

extension UIScrollView {

    var rx_reachedBottom: Observable<Void> {
        return rx.contentOffset
            .flatMap { [weak self] contentOffset -> Observable<Void> in
                guard let scrollView = self else {
                    return Observable.empty()
                }

                let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
                let y = contentOffset.y + scrollView.contentInset.top
                let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)

                return y > threshold ? Observable.just(Void()) : Observable.empty()
        }
    }
}
