//
//  LikerListViewReactor.swift
//  qiigle
//
//  Created by 島田智貴 on 2019/07/14.
//  Copyright © 2019 Tomozip. All rights reserved.
//

import ReactorKit
import RxSwift

final class LikerListViewReactor: Reactor {
    enum Action {
        case initialLoad
        case loadNewPage
    }

    enum Mutation {
        case setIsLoading(Bool)
        case increasePage
        case loadLikes([Like])
        case appendLikes([Like])
    }

    struct State {
        var article: Article
        var page: Int
        var likes: [Like]
        var isLoading: Bool
    }

    let initialState: State

    init(article: Article) {
        initialState = State(
            article: article,
            page: 1,
            likes: [],
            isLoading: false
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .initialLoad:
            return loadLikes(page: currentState.page).map(Mutation.loadLikes)
        case .loadNewPage:
            return Observable.concat([
                Observable.just(Mutation.setIsLoading(true)),
                loadLikes(page: currentState.page + 1).map(Mutation.appendLikes),
                Observable.just(Mutation.increasePage),
                Observable.just(Mutation.setIsLoading(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .loadLikes(likes):
            state.likes = likes
        case let .setIsLoading(isLoading):
            state.isLoading = isLoading
        case .increasePage:
            state.page += 1
        case let .appendLikes(likes):
            state.likes.append(contentsOf: likes)
        }

        return state
    }

    private func loadLikes(page: Int) -> Observable<[Like]> {
        return QiitaRepository.likes(articleId: currentState.article.id, page: page).asObservable()
    }
}
