//
//  HomeViewController.swift
//  qiigle
//
//  Created by 島田智貴 on 2019/07/13.
//  Copyright © 2019 Tomozip. All rights reserved.
//

import ReactorKit
import ReusableKit
import RxSwift
import Then
import UIKit
import Kingfisher

final class HomeViewController: UIViewController, ReactorKitView, ViewConstructor {
    typealias Reactor = HomeViewReactor

    struct Const {
        static let userCountViewHeight: CGFloat = 32
    }

    struct Reusable {
        static let articleCell = ReusableCell<ArticleCell>()
    }

    // MARK: - Variables

    var disposeBag = DisposeBag()

    // MARK: - Views

    private lazy var headerView = UIView().then {
        $0.backgroundColor = Color.primaryColor
    }

    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.itemSize = ArticleCell.Const.cellSize
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = ArticleCell.Const.minimumLineSpacing
        $0.minimumInteritemSpacing = ArticleCell.Const.minimumLineSpacing
        $0.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }

    private lazy var titleLabel = UILabel().then {
        $0.text = "Qiigle"
        $0.apply(isBold: true, size: 40, color: Color.primaryColor)
    }

    private lazy var searchField = TextField().then {
        $0.placeholder = "キーワードを入力"
        $0.returnKeyType = .search
        $0.clearButtonMode = .always
        $0.backgroundColor = Color.textFieldBackColor
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
    }

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.backgroundColor = .clear
        $0.alwaysBounceVertical = true
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.register(Reusable.articleCell)
        $0.dataSource = self
        $0.delegate = self
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupViewConstraints()
        setupButtons()
        setupGestureRecognizers()
        setupFunctions()
    }

    // MARK: - Setup Methods

    func setupViews() {
        view.backgroundColor = .white

        view.addSubview(titleLabel)
        view.addSubview(searchField)
        view.addSubview(collectionView)
    }

    func setupViewConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.centerX.equalToSuperview()
        }
        searchField.snp.makeConstraints {
            $0.height.equalTo(36)
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.left.right.equalToSuperview().inset(16)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchField.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
    }

    func setupButtons() {}

    func setupGestureRecognizers() {}

    private func setupFunctions() {
        collectionView.rx.itemSelected
            .map { [weak self] indexPath in self?.reactor?.currentState.articles[indexPath.item] }
            .filterNil()
            .bind { [weak self] article in
//                self?.showUserPage(user: user)
                print(article.title)
            }
            .disposed(by: disposeBag)

        searchField.rx.controlEvent(.editingDidEndOnExit).subscribe { [weak self] _ in
            self?.reactor?.action.onNext(.loadArticles)
        }.disposed(by: disposeBag)

        searchField.rx.text.orEmpty.distinctUntilChanged().subscribe { [weak self] in
            self?.reactor?.action.onNext(.changeQuery($0.element.value!))
        }.disposed(by: disposeBag)

//        searchField.rx.observe(String.self, "text").distinctUntilChanged().subscribe { [weak self] in
//            self?.reactor?.action.onNext(.changeQuery($0.element!.value!))
//        }.disposed(by: disposeBag)

//        searchField.rx.controlEvent(.valueChanged).subscribe { [weak self] in
//            self?.reactor?.action.onNext(.changeQuery($0))
//        }.disposed(by: disposeBag)
    }

    // MARK: - Bind

    func bind(reactor: HomeViewReactor) {
        // Action
        reactor.action.onNext(.loadTrends)

        // State
        reactor.state.map { $0.articles }
            .filter { !$0.isEmpty }
            .bind { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .disposed(by: disposeBag)

//        reactor.state.map { $0.users.count.description }
//            .bind(to: countLabel.rx.text)
//            .disposed(by: disposeBag)
    }

    //    private func presentSubscritptionModal() {
    //        guard let reactor = reactor else { return }
    //        let subscriptionReactor = reactor.reactorForSubscriptionModal()
    //        let subscriptionModalView: SubscriptionModalViewController = .instantiate()
    //        subscriptionModalView.reactor = subscriptionReactor
    //
    //        let navigationCotroller = UINavigationController(rootViewController: subscriptionModalView)
    //
    //        navigationController?.present(navigationCotroller, animated: true)
    //    }

//    private func showUserPage(user: User) {
//        let userPageViewController = UserPageViewController().then {
//            $0.reactor = UserPageViewReactor(user: user)
//        }
//
//        navigationController?.pushViewController(userPageViewController, animated: true)
//    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reactor?.currentState.articles.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let article = reactor?.currentState.articles[indexPath.item] else { fatalError() }

        return collectionView.dequeue(Reusable.articleCell, for: indexPath).then {
            $0.setupArticleInfo(article: article)
        }
    }
}
