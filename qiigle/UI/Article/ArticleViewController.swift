//
//  ArticleViewController.swift
//  qiigle
//
//  Created by 島田智貴 on 2019/07/14.
//  Copyright © 2019 Tomozip. All rights reserved.
//

import RxSwift
import Then
import UIKit
import Kingfisher

final class ArticleViewController: UIViewController, ViewConstructor {

    // MARK: - Variables

    let disposeBag = DisposeBag()

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

    private lazy var scrollView = UIScrollView().then {
        $0.addSubview(headerView)
    }

    private lazy var headerView = UIView().then {
        $0.backgroundColor = Color.lightHeaderBackColor
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        $0.addSubview(titleLabel)
        $0.addSubview(writerView)
        $0.addSubview(likeCountView)
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

    private lazy var likeCountView = UIView().then {
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
            $0.edges.equalToSuperview()
        }
        headerView.snp.makeConstraints {
            $0.left.top.equalToSuperview()
            $0.width.equalTo(view.frame.width)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(180)
        }
        titleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(12)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(54)
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
        likeCountView.snp.makeConstraints {
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
    }

    func setupButtons() {
        backButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }

    func setupGestureRecognizers() {}

    private func setupFunctions() {}

    func setupArticleInfo(article: Article) {
        userImageView.kf.setImage(with: URL(string: article.user.profileImageUrl))
        titleLabel.text = article.title
        userNameLabel.text = article.user.id
        createdAtLabel.text = Date.from(string: article.createdAt).offsetFrom()
        likeCountLabel.attributedText = NSAttributedString(string: article.likesCount.description, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
}
