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

    struct Reusable {
        static let articleCell = ReusableCell<ArticleCell>()
    }

    // MARK: - Variables

    var disposeBag = DisposeBag()

    // MARK: - Views

    private lazy var presentingView = UIView().then {
        $0.isHidden = true
        $0.backgroundColor = UIColor.init(hex: "FFFFFF", alpha: 0.5)
        $0.addSubview(presentingIndicator)
    }

    private let presentingIndicator = UIActivityIndicatorView().then {
        $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        $0.style = UIActivityIndicatorView.Style.gray
        $0.startAnimating()
    }

    private let headerView = UIView().then {
        $0.backgroundColor = Color.primaryColor
    }

    private let titleLabel = UILabel().then {
        $0.text = "Qiigle"
        $0.apply(isBold: true, size: 40, color: Color.primaryColor)
    }

    private let searchField = TextField().then {
        $0.placeholder = "キーワードを入力"
        $0.returnKeyType = .search
        $0.clearButtonMode = .always
        $0.backgroundColor = Color.textFieldBackColor
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
    }

    private lazy var searchButtonsView = UIView().then {
        $0.addSubview(trendsButton)
        $0.addSubview(searchButton)
    }

    private let trendsButton = UIButton().then {
        $0.backgroundColor = .white
        $0.layer.borderColor = Color.primaryColor.cgColor
        $0.layer.borderWidth = 1
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 4
        $0.setTitle(isBold: false, color: Color.primaryColor, fontSize: 14, text: "おすすめ記事")
    }

    private let searchButton = UIButton().then {
        $0.backgroundColor = Color.primaryColor
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 4
        $0.setTitle(color: .white, fontSize: 14, text: "検索")
    }

    private let collectionViewTitleLabel = UILabel().then {
        $0.apply(isBold: true, size: 14, color: Color.textColor)
    }

    private lazy var loadingView = UIView().then {
        $0.backgroundColor = UIColor.init(hex: "FFFFFF", alpha: 0.5)
        $0.addSubview(activityIndicator)
    }

    private let activityIndicator = UIActivityIndicatorView().then {
        $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        $0.style = UIActivityIndicatorView.Style.gray
        $0.startAnimating()
    }

    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.itemSize = ArticleCell.Const.cellSize
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = ArticleCell.Const.minimumLineSpacing
        $0.minimumInteritemSpacing = ArticleCell.Const.minimumLineSpacing
        $0.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        $0.footerReferenceSize = CGSize(width: DeviceSize.screenWidth, height: 0)
    }

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.backgroundColor = .clear
        $0.alwaysBounceVertical = true
        $0.contentInsetAdjustmentBehavior = .never
        $0.register(Reusable.articleCell)
        $0.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CartFooterCollectionReusableView")
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
        view.addSubview(searchButtonsView)
        view.addSubview(collectionViewTitleLabel)
        view.addSubview(collectionView)
        view.addSubview(loadingView)
        view.addSubview(presentingView)
    }

    func setupViewConstraints() {
        presentingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        presentingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.centerX.equalToSuperview()
        }
        searchField.snp.makeConstraints {
            $0.height.equalTo(36)
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.left.right.equalToSuperview().inset(16)
        }
        searchButtonsView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(searchField.snp.bottom).offset(12)
        }
        trendsButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 112, height: 34))
            $0.left.top.bottom.equalToSuperview()
        }
        searchButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 112, height: 34))
            $0.left.equalTo(trendsButton.snp.right).offset(12)
            $0.top.right.bottom.equalToSuperview()
        }
        collectionViewTitleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(12)
            $0.top.equalTo(searchButtonsView.snp.bottom).offset(24)
        }
        loadingView.snp.makeConstraints {
            $0.edges.equalTo(collectionView)
        }
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(collectionViewTitleLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
    }

    func setupButtons() {
        searchButton.rx.tap
            .bind { [weak self] in
                self?.reactor?.action.onNext(.loadArticles)
            }.disposed(by: disposeBag)

        trendsButton.rx.tap
            .bind { [weak self] in
                self?.reactor?.action.onNext(.loadTrends)
            }.disposed(by: disposeBag)
    }

    func setupGestureRecognizers() {}

    private func setupFunctions() {
        collectionView.rx.itemSelected
            .map { [weak self] indexPath in self?.reactor?.currentState.articles[indexPath.item] }
            .filterNil()
            .bind { [weak self] article in
                self?.presentArticleVC(article: article)
            }
            .disposed(by: disposeBag)

        collectionView.rx_reachedBottom.bind { [weak self] (_) in
            guard self?.reactor?.currentState.isLoadingNewPage == false else { return }
            self?.reactor?.action.onNext(.loadNewPage)
        }.disposed(by: disposeBag)

        searchField.rx.controlEvent(.editingDidEndOnExit).subscribe { [weak self] _ in
            self?.reactor?.action.onNext(.loadArticles)
        }.disposed(by: disposeBag)

        searchField.rx.text.orEmpty.distinctUntilChanged().subscribe { [weak self] in
            self?.reactor?.action.onNext(.changeQuery($0.element.value!))
        }.disposed(by: disposeBag)
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

        reactor.state.map { $0.collectionViewTitle }
            .bind(to: collectionViewTitleLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind { [weak self] isLoading in
                self?.loadingView.isHidden = !isLoading
                if !isLoading {
                    self?.collectionView.contentOffset.y = 0
                }
            }
            .disposed(by: disposeBag)

        reactor.state.map { $0.isLoadingNewPage }
            .bind { [weak self] isLoading in
                self?.flowLayout.footerReferenceSize = CGSize(width: DeviceSize.screenWidth, height: (isLoading ? 100 : 0))
            }.disposed(by: disposeBag)
    }

    private func presentArticleVC(article: Article) {
        presentingView.isHidden = false

        let articleViewController = ArticleViewController().then {
            $0.reactor = ArticleViewReactor(article: article)
        }
        navigationController?.pushViewController(articleViewController, animated: true)

        presentingView.isHidden = true
    }
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

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if (kind == UICollectionView.elementKindSectionFooter) {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CartFooterCollectionReusableView", for: indexPath)

            let activityIndicator = UIActivityIndicatorView(style: .gray)
            activityIndicator.startAnimating()
            footerView.addSubview(activityIndicator)
            activityIndicator.snp.makeConstraints {
                $0.centerY.equalToSuperview().offset(-10)
                $0.centerX.equalToSuperview()
            }

            return footerView
        } else if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CartHeaderCollectionReusableView", for: indexPath)
            // Customize headerView here
            return headerView
        }
        fatalError()
    }
}
