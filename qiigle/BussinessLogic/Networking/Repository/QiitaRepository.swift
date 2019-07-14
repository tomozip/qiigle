//
//  QiitaRepository.swift
//  qiigle
//
//  Created by 島田智貴 on 2019/07/13.
//  Copyright © 2019 Tomozip. All rights reserved.
//

import Moya
import RxMoya
import RxSwift

protocol QiitaRepositoryType {
    static func articles(query: String, page: Int) -> Single<[Article]>
    static func trends(page: Int) -> Single<[Article]>
}

struct QiitaRepository: QiitaRepositoryType {
    private init() {}

    private static let provider = NetworkProvider<QiitaTarget>()

    static func articles(query: String, page: Int) -> Single<[Article]> {
        return provider.rx.request(.articles(query, page))
            .filterSuccessfulStatusCodes()
            .map([Article].self)
    }

    static func trends(page: Int) -> Single<[Article]> {
        return provider.rx.request(.trends(page))
            .filterSuccessfulStatusCodes()
            .map([Article].self)
    }
}
