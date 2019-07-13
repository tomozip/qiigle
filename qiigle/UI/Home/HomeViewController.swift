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

final class HomeViewController: UIViewController, ReactorKitView, ViewConstructor, TransitionPresentable {
    typealias Reactor = HomeViewReactor

    struct Const {
        static let userCountViewHeight: CGFloat = 32
    }

    struct Reusable {
        static let userCell = ReusableCell<UserCell>()
    }

    // MARK: - Variables

    var disposeBag = DisposeBag()

    // MARK: - Views

    private lazy var headerView = UIView().then {
        $0.backgroundColor = Color.primaryColor
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
        view.backgroundColor = Color.bg

        view.addSubview(headerView)
        //        view.addSubview(loadingCollectionView)
    }

    func setupViewConstraints() {
//        headerView.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.width.equalToSuperview()
//            $0.height.equalTo(64)
//        }
    }

    func setupButtons() {}

    func setupGestureRecognizers() {}

    private func setupFunctions() {
        collectionView.rx.itemSelected
            .map { [weak self] indexPath in self?.reactor?.currentState.users[indexPath.item] }
            .filterNil()
            .bind { [weak self] user in
                self?.showUserPage(user: user)
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Bind

    func bind(reactor: HomeViewReactor) {
        // Action
        reactor.action.onNext(.load)

        // State
        reactor.state.map { $0.users }
            .filter { !$0.isEmpty }
            .bind { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .disposed(by: disposeBag)

        reactor.state.map { $0.users.count.description }
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
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

    private func showUserPage(user: User) {
        let userPageViewController = UserPageViewController().then {
            $0.reactor = UserPageViewReactor(user: user)
        }

        navigationController?.pushViewController(userPageViewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reactor?.currentState.users.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let user = reactor?.currentState.users[indexPath.item] else { fatalError() }

        return collectionView.dequeue(Reusable.userCell, for: indexPath).then {
            $0.setupUserInfo(user: user)
        }
    }
}
