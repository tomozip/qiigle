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
    static func articles(query: String) -> Single<[Article]>
    static func trends() -> Single<[Article]>
}

struct QiitaRepository: QiitaRepositoryType {
    private init() {}

    private static let provider = NetworkProvider<QiitaTarget>()

    static func articles(query: String) -> Single<[Article]> {
        return provider.rx.request(.articles(query))
            .filterSuccessfulStatusCodes()
            .map([Article].self)
    }

    static func trends() -> Single<[Article]> {
        return provider.rx.request(.trends)
            .filterSuccessfulStatusCodes()
            .map([Article].self)
    }
}
