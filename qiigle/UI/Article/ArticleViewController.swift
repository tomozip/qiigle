//
//  ArticleViewController.swift
//  qiigle
//
//  Created by 島田智貴 on 2019/07/14.
//  Copyright © 2019 Tomozip. All rights reserved.
//

import RxSwift
import ReactorKit
import Then
import UIKit
import Kingfisher
import SwiftyMarkdown

final class ArticleViewController: UIViewController, ReactorKitView, ViewConstructor {

    typealias Reactor = ArticleViewReactor

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

    private lazy var scrollView = UIScrollView(frame: DeviceSize.screenBounds).then {
        $0.backgroundColor = .white
        $0.addSubview(headerView)
        $0.addSubview(renderedTextLabel)
    }

    private lazy var headerView = UIView().then {
        $0.frame.origin = .zero
        $0.frame.size = CGSize(width: DeviceSize.screenWidth, height: 180)
        $0.backgroundColor = Color.lightHeaderBackColor
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        $0.addSubview(titleLabel)
        $0.addSubview(writerView)
        $0.addSubview(likeCountButton)
    }

    private let titleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.apply(isBold: true, size: 20, color: Color.textColor)
    }

    private lazy var writerView = UILabel().then {
        $0.addSubview(userImageView)
        $0.addSubview(userNameLabel)
        $0.addSubview(createdAtLabel)
    }

    private let userImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 4
    }

    private let userNameLabel = UILabel().then {
        $0.apply(size: 20, color: Color.textColor)
    }

    private let createdAtLabel = UILabel().then {
        $0.apply(isBold: true, size: 12, color: Color.lightTextColor)
    }

    private lazy var likeCountButton = UIButton().then {
        $0.addSubview(likeImageView)
        $0.addSubview(likeCountLabel)
    }

    private let likeImageView = ImageView().then {
        $0.image = R.image.like()?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = Color.primaryColor
    }

    private let likeCountLabel = UILabel().then {
        $0.apply(size: 24, color: Color.primaryColor)
        $0.textAlignment = .right
    }

    private lazy var renderedTextLabel = UILabel().then {
        $0.numberOfLines = 0
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
        view.backgroundColor = Color.lightHeaderBackColor

        view.addSubview(scrollView)
        view.addSubview(backButton)
    }

    func setupViewConstraints() {
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
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.right.bottom.equalToSuperview()
        }
//        headerView.snp.makeConstraints {
//            $0.left.right.equalToSuperview()
//            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(180)
//        }
        titleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(12)
            $0.top.equalToSuperview().offset(54)
        }
        writerView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(20)
        }
        userImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.left.top.bottom.equalToSuperview()
        }
        userNameLabel.snp.makeConstraints {
            $0.left.equalTo(userImageView.snp.right).offset(8)
            $0.top.equalToSuperview()
        }
        createdAtLabel.snp.makeConstraints {
            $0.left.equalTo(userImageView.snp.right).offset(8)
            $0.bottom.equalToSuperview()
        }
        likeCountButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(20)
        }
        likeImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 16, height: 16))
            $0.right.equalTo(likeCountLabel.snp.left).offset(-6)
            $0.bottom.equalTo(likeCountLabel).offset(-3)
        }
        likeCountLabel.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        renderedTextLabel.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(12)
            $0.width.equalTo(DeviceSize.screenWidth - 24)
        }
    }

    func setupButtons() {

        backButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)

        likeCountButton.rx.tap
            .bind { [weak self] in
                self?.presentLikerListVC()
            }.disposed(by: disposeBag)
    }

    func setupGestureRecognizers() {}

    private func setupFunctions() {}

    func bind(reactor: ArticleViewController.Reactor) {

        reactor.state.map { $0.article }
            .bind { [weak self] article in
                self?.userImageView.kf.setImage(with: URL(string: article.user.profileImageUrl))
                self?.titleLabel.text = article.title
                self?.userNameLabel.text = article.user.id
                self?.createdAtLabel.text = Date.from(string: article.createdAt).offsetFrom()
                self?.likeCountLabel.attributedText = NSAttributedString(string: article.likesCount.description, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])

                self?.renderedTextLabel.attributedText = article.renderedBody.convertHtml().attributedStringWithResizedImages(with: DeviceSize.screenWidth - 24)
                self?.runAfterDelay(delay: 0.1) { [weak self] in
                    self?.renderedTextLabel.sizeToFit()
                    self?.scrollView.contentSize.height = self!.renderedTextLabel.frame.height + 220
                }
            }.disposed(by: disposeBag)
    }

    private func presentLikerListVC() {
        let likerListViewController = LikerListViewController().then {
            $0.reactor = LikerListViewReactor(article: reactor!.currentState.article)
        }
        navigationController?.pushViewController(likerListViewController, animated: true)
    }

    func runAfterDelay(delay: TimeInterval, block: @escaping () -> Void) {
        let time = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: time) {
            block()
        }
    }
}
