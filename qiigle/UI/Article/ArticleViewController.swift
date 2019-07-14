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
import SwiftyMarkdown

final class ArticleViewController: UIViewController, ViewConstructor {

    // MARK: - Variables

    let disposeBag = DisposeBag()

    // MARK: - Views

    private lazy var statusBarBackView = UIView().then {
        $0.backgroundColor = Color.lightHeaderBackColor
    }

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
        $0.addSubview(markdownLabel)
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

    private lazy var markdownLabel = UILabel().then {
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

//        view.addSubview(statusBarBackView)
        view.addSubview(scrollView)
        view.addSubview(backButton)
    }

    func setupViewConstraints() {
//        statusBarBackView.snp.makeConstraints {
//            $0.left.top.right.equalToSuperview()
//            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
//        }
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
        markdownLabel.snp.makeConstraints {
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
    }

    func setupGestureRecognizers() {}

    private func setupFunctions() {}

    func setupArticleInfo(article: Article) {
        userImageView.kf.setImage(with: URL(string: article.user.profileImageUrl))
        titleLabel.text = article.title
        userNameLabel.text = article.user.id
        createdAtLabel.text = Date.from(string: article.createdAt).offsetFrom()
        likeCountLabel.attributedText = NSAttributedString(string: article.likesCount.description, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        UIView.animate(withDuration: 0, animations: { [weak self] in
            self?.markdownLabel.attributedText = SwiftyMarkdown(string: article.body).attributedString()
            self?.markdownLabel.sizeToFit()
        }) { [weak self] (_) in
            self?.scrollView.contentSize.height = self!.markdownLabel.frame.height + 220
        }
    }
}
