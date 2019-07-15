//
//  ArticleViewReactor.swift
//  qiigle
//
//  Created by 島田智貴 on 2019/07/15.
//  Copyright © 2019 Tomozip. All rights reserved.
//

import ReactorKit
import RxSwift

final class ArticleViewReactor: Reactor {

    struct Action {}

    struct State {
        var article: Article
    }

    let initialState: State

    init(article: Article) {
        initialState = State(
            article: article
        )
    }
}
