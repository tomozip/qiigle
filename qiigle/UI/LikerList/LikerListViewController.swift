//
//  LikerListViewController.swift
//  qiigle
//
//  Created by 島田智貴 on 2019/07/14.
//  Copyright © 2019 Tomozip. All rights reserved.
//

import RxSwift
import Then
import UIKit
import Kingfisher
import SwiftyMarkdown

final class LikerListViewController: UIViewController, ReactorKitView, ViewConstructor {

    typealias Reactor = LikerListViewReactor

    // MARK: - Variables
    var disposeBag = DisposeBag()

    // MARK: - Views

    private lazy var backButton = UIButton().then {
        $0.backgroundColor = Color.primaryColor
        $0.shadow()
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
        $0.addSubview(backButtonImageView)
    }

    private let backButtonImageView = UIImageView().then {
        $0.image = R.image.leftArrow()?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .white
    }

    private let titleLabel = UILabel().then {
        $0.text = "いいねしたユーザー"
        $0.apply(isBold: false, size: 24, color: Color.textColor)
        $0.backgroundColor = .white
        $0.textAlignment = .center
    }

    private lazy var tableView = UITableView().then {
        $0.alwaysBounceVertical = true
        $0.contentInsetAdjustmentBehavior = .never
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "UserCell")
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "tableFooterCell")
        $0.delegate = self
        $0.dataSource = self
    }

    private lazy var tableFooterView: UIView = {
        let footerCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableFooterCell")!
        let footerView: UIView = footerCell.contentView
        return footerView
    }()

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
        view.addSubview(backButton)
        view.addSubview(tableView)
    }

    func setupViewConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            $0.left.right.equalToSuperview()
        }
        backButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 32, height: 32))
            $0.left.equalToSuperview().inset(12)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
        }
        backButtonImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 20, height: 20))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(5)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.left.right.bottom.equalToSuperview()
        }
    }

    func setupButtons() {
        backButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }

    func setupGestureRecognizers() {}

    private func setupFunctions() {

        tableView.rx_reachedBottom.bind { [weak self] (_) in
            guard let state = self?.reactor?.currentState, state.isLoading == false else { return }
            guard state.likes.count < state.article.likesCount else { return }
            self?.reactor?.action.onNext(.loadNewPage)
        }.disposed(by: disposeBag)
    }

    // MARK: - Bind

    func bind(reactor: LikerListViewReactor) {
        // Action
        reactor.action.onNext(.initialLoad)

        // State
        reactor.state.map { $0.likes }
            .filter { !$0.isEmpty }
            .bind { [weak self] _ in
                self?.tableView.reloadData()
            }
            .disposed(by: disposeBag)

        reactor.state.map { $0.isLoading }
            .bind { [weak self] isLoading in
                self?.tableView.tableFooterView = isLoading ? self?.tableFooterView : nil
            }.disposed(by: disposeBag)
    }
}

extension LikerListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reactor?.currentState.likes.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

        cell.contentView.subviews.forEach {
            $0.removeFromSuperview()
        }

        let userImageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 4
        }
        cell.contentView.addSubview(userImageView)
        userImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.left.top.bottom.equalToSuperview().inset(8)
        }

        let userNameLabel = UILabel().then {
            $0.apply(size: 20, color: Color.textColor)
        }
        cell.contentView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints {
            $0.left.equalTo(userImageView.snp.right).offset(8)
            $0.centerY.equalToSuperview()
        }

        let user = reactor!.currentState.likes[indexPath.row].user
        userImageView.kf.setImage(with: URL(string: user.profileImageUrl))
        userNameLabel.text = user.id

        return cell
    }
}
