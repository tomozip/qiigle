//
//  HomeViewReactor.swift
//  qiigle
//
//  Created by 島田智貴 on 2019/07/13.
//  Copyright © 2019 Tomozip. All rights reserved.
//

import ReactorKit
import RxSwift

final class HomeViewReactor: Reactor {
    enum Action {
        case changeQuery(String)
        case loadNewPage
        case loadTrends
        case loadArticles
    }

    enum Mutation {
        case setQuery(String)
        case setIsLoading(Bool)
        case setIsLoadingNewPage(Bool)
        case increasePage
        case resetPage
        case appendArticles([Article])
        case setTrends([Article])
        case setArticles([Article])
    }

    struct State {
        var page: Int
        var query: String
        var trends: [Article]
        var articles: [Article]
        var isLoading: Bool
        var isLoadingNewPage: Bool
    }

    let initialState: State

    init() {
        initialState = State(
            page: 1,
            query: "",
            trends: [],
            articles: [],
            isLoading: false,
            isLoadingNewPage: false
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .changeQuery(query):
            return Observable.just(Mutation.setQuery(query))
        case .loadNewPage:
            return Observable.concat([
                Observable.just(Mutation.setIsLoadingNewPage(true)),
                (currentState.query.isEmpty ?
                    loadTrends(page: currentState.page + 1).map(Mutation.appendArticles) :
                    loadArticles(query: currentState.query, page: currentState.page + 1).map(Mutation.appendArticles)
                ),
                Observable.just(Mutation.increasePage),
                Observable.just(Mutation.setIsLoadingNewPage(false))
            ])
        case .loadTrends:
            return Observable.concat([
                    Observable.just(Mutation.setIsLoading(true)),
                    Observable.just(Mutation.resetPage),
                    self.loadTrends(page: currentState.page).map(Mutation.setTrends),
                    Observable.just(Mutation.setIsLoading(false))
                ])
        case .loadArticles:
            return Observable.concat([
                Observable.just(Mutation.setIsLoading(true)),
                Observable.just(Mutation.resetPage),
                self.loadArticles(query: currentState.query, page: currentState.page).map(Mutation.setArticles),
                Observable.just(Mutation.setIsLoading(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setQuery(query):
            state.query = query
        case let .setIsLoading(isLoading):
            state.isLoading = isLoading
        case let .setIsLoadingNewPage(isLoading):
            state.isLoadingNewPage = isLoading
        case .increasePage:
            state.page += 1
        case .resetPage:
            state.page = 1
        case let .appendArticles(articles):
            state.articles.append(contentsOf: articles)
        case .setArticles(let articles):
            state.articles = articles
        case let .setTrends(trends):
            state.trends = trends
            state.articles = trends
        }

        return state
    }

    private func loadArticles(query: String, page: Int) -> Observable<[Article]> {
        return QiitaRepository.articles(query: query, page: page).asObservable()
    }

    private func loadTrends(page: Int) -> Observable<[Article]> {
        return QiitaRepository.trends(page: page).asObservable()
    }

    //    func reactorForSubscriptionModal() -> SubscriptionModalReactor {
    //        return SubscriptionModalReactor(provider: provider)
    //    }
    //
    //    func reactorForPlaylist(playlist: Playlist, currentTrackIndex: Int) -> PlaylistReactor {
    //        return PlaylistReactor(playlist: playlist, currentTrackIndex: currentTrackIndex, provider: provider)
    //    }
}
