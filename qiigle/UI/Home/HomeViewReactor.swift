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

    enum RequestAction {
        case loadNewPage
        case loadTrends
        case loadArticles
    }

    enum Action {
        case changeQuery(String)
        case retryRequest
        case loadNewPage
        case loadTrends
        case loadArticles
        case resetShouldAlertRetry
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
        case setShouldAlertRetry(Bool)
        case setRetryableRequest(RequestAction)
        case setCollectionViewTitle(String)
    }

    struct State {
        var page: Int
        var query: String
        var trends: [Article]
        var articles: [Article]
        var isLoading: Bool
        var isLoadingNewPage: Bool
        var shouldAlertRetry: Bool
        var retryableRequest: RequestAction?
        var collectionViewTitle: String
    }

    let initialState: State

    init() {
        initialState = State(
            page: 1,
            query: "",
            trends: [],
            articles: [],
            isLoading: false,
            isLoadingNewPage: false,
            shouldAlertRetry: false,
            retryableRequest: nil,
            collectionViewTitle: "おすすめ記事"
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .changeQuery(query):
            return Observable.just(Mutation.setQuery(query))
        case .retryRequest:
            retryAPIRequest()
            return Observable.empty()
        case .loadNewPage:
            return Observable.concat([
                Observable.just(Mutation.setIsLoadingNewPage(true)),
                Observable.just(Mutation.setRetryableRequest(.loadNewPage)),
                (currentState.query.isEmpty ?
                    loadTrends(page: currentState.page + 1).map(Mutation.appendArticles).catchErrorJustReturn(Mutation.setShouldAlertRetry(true)) :
                    loadArticles(query: currentState.query, page: currentState.page + 1).map(Mutation.appendArticles).catchErrorJustReturn(Mutation.setShouldAlertRetry(true))
                ),
                Observable.just(Mutation.increasePage),
                Observable.just(Mutation.setIsLoadingNewPage(false))
            ])
        case .loadTrends:
            return Observable.concat([
                    Observable.just(Mutation.setCollectionViewTitle("おすすめ記事")),
                    Observable.just(Mutation.setIsLoading(true)),
                    Observable.just(Mutation.resetPage),
                    Observable.just(Mutation.setRetryableRequest(.loadTrends)),
                    self.loadTrends(page: currentState.page)
                        .map(Mutation.setTrends)
                        .catchErrorJustReturn(Mutation.setShouldAlertRetry(true)),
                    Observable.just(Mutation.setIsLoading(false))
                ])
        case .loadArticles:
            guard !currentState.query.isEmpty else { return Observable.empty() }
            return Observable.concat([
                Observable.just(Mutation.setCollectionViewTitle("検索結果")),
                Observable.just(Mutation.setIsLoading(true)),
                Observable.just(Mutation.resetPage),
                Observable.just(Mutation.setRetryableRequest(.loadArticles)),
                self.loadArticles(query: currentState.query, page: currentState.page)
                    .map(Mutation.setArticles)
                    .catchErrorJustReturn(Mutation.setShouldAlertRetry(true)),
                Observable.just(Mutation.setIsLoading(false))
            ])
        case .resetShouldAlertRetry:
            return Observable.just(Mutation.setShouldAlertRetry(false))
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
        case let .setShouldAlertRetry(shouldAlert):
            state.shouldAlertRetry = shouldAlert
        case let .setRetryableRequest(requestAction):
            state.retryableRequest = requestAction
        case let .setCollectionViewTitle(title):
            state.collectionViewTitle = title
        }

        return state
    }

    private func retryAPIRequest() {
        guard let retryableRequest = currentState.retryableRequest else { return }

        switch retryableRequest {
        case .loadNewPage:  action.onNext(.loadNewPage)
        case .loadTrends:   action.onNext(.loadTrends)
        case .loadArticles: action.onNext(.loadArticles)
        }
    }

    private func loadArticles(query: String, page: Int) -> Observable<[Article]> {
        return QiitaRepository.articles(query: query, page: page).asObservable()
    }

    private func loadTrends(page: Int) -> Observable<[Article]> {
        return QiitaRepository.trends(page: page).asObservable()
    }
}
