//
//  HomeViewReactor.swift
//  qiigle
//
//  Created by 島田智貴 on 2019/07/13.
//  Copyright © 2019 Tomozip. All rights reserved.
//

import ReactorKit
import RxSwift

protocol HomeContentReactor {}

final class HomeViewReactor: Reactor {
    enum Action {
        case changeQuery(String)
        case loadTrends
        case loadArticles
    }

    enum Mutation {
        case setQuery(String)
        case setShouldShowTrends(Bool)
        case setArticles([Article])
        case setTrends([Article])
    }

    struct State {
        var query: String
        var trends: [Article]
        var articles: [Article]
        var shouldShowTrends: Bool
    }

    let initialState: State

    init() {
        initialState = State(
            query: "",
            trends: [],
            articles: [],
            shouldShowTrends: false
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .changeQuery(query):
            return Observable.just(Mutation.setQuery(query))
        case .loadTrends:
            return self.loadTrends().map(Mutation.setTrends)
        case .loadArticles:
            return self.loadArticles(query: currentState.query).map { Mutation.setArticles($0) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setQuery(query):
            state.query = query
        case .setShouldShowTrends(let shouldShow):
            state.shouldShowTrends = shouldShow
        case .setArticles(let articles):
            state.articles = articles
        case let .setTrends(trends):
            state.trends = trends
            state.articles = trends
        }

        return state
    }

    private func loadArticles(query: String) -> Observable<[Article]> {
        return QiitaRepository.articles(query: query).asObservable()
    }

    private func loadTrends() -> Observable<[Article]> {
        return QiitaRepository.trends().asObservable()
    }

    //    func reactorForSubscriptionModal() -> SubscriptionModalReactor {
    //        return SubscriptionModalReactor(provider: provider)
    //    }
    //
    //    func reactorForPlaylist(playlist: Playlist, currentTrackIndex: Int) -> PlaylistReactor {
    //        return PlaylistReactor(playlist: playlist, currentTrackIndex: currentTrackIndex, provider: provider)
    //    }
}
