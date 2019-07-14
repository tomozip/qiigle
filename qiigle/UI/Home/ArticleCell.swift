//
//  ArticleCell.swift
//  qiigle
//
//  Created by 島田智貴 on 2019/07/14.
//  Copyright © 2019 Tomozip. All rights reserved.
//

import Kingfisher
import RxSwift
import Then
import SnapKit
import UIKit

final class ArticleCell: UICollectionViewCell, ViewConstructor {

    struct Const {
        static let cellSize = CGSize(width: DeviceSize.screenWidth - 24, height: 104)
        static let minimumLineSpacing: CGFloat = 12
    }

    // MARK: Variables

    var disposeBag = DisposeBag()

    // MARK: - Views

    private let titleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.apply(isBold: true, size: 16, color: Color.textColor)
    }

    private let userImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 4
    }

    private lazy var writerView = UILabel().then {
        $0.addSubview(userImageView)
        $0.addSubview(writerPrefixLabel)
        $0.addSubview(userNameLabel)
        $0.addSubview(createdAtLabel)
    }

    private let writerPrefixLabel = UILabel().then {
        $0.text = "by"
        $0.apply(size: 12, color: Color.lightTextColor)
    }
    private let userNameLabel = UILabel().then {
        $0.apply(size: 12, color: Color.lightTextColor)
    }

    private let createdAtLabel = UILabel().then {
        $0.apply(size: 12, color: Color.lightTextColor)
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

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupViewConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    func setupViews() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 4
        contentView.shadow()

        contentView.addSubview(titleLabel)
        contentView.addSubview(writerView)
        contentView.addSubview(likeCountView)
    }

    func setupViewConstraints() {
        titleLabel.snp.makeConstraints {
            $0.left.top.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-12)
            $0.height.equalTo(48)
        }
        writerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-12)
        }
        userImageView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.size.equalTo(CGSize(width: 24, height: 24))
        }
        writerPrefixLabel.snp.makeConstraints {
            $0.left.equalTo(userImageView.snp.right).offset(8)
            $0.bottom.equalToSuperview()
        }
        userNameLabel.snp.makeConstraints {
            $0.left.equalTo(writerPrefixLabel.snp.right).offset(4)
            $0.bottom.equalToSuperview()
        }
        createdAtLabel.snp.makeConstraints {
            $0.left.equalTo(userNameLabel.snp.right).offset(4)
            $0.bottom.equalToSuperview()
        }
        likeCountView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.right.bottom.equalToSuperview().offset(-12)
        }
        likeImageView.snp.makeConstraints {
            $0.right.equalTo(likeCountLabel.snp.left).offset(-4)
            $0.bottom.equalToSuperview().offset(-3)
            $0.size.equalTo(CGSize(width: 16, height: 16))
        }
        likeCountLabel.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
        }
    }

    func setupButtons() {}

    func setupGestureRecognizers() {}

    // MARK: - Bind

    func setupArticleInfo(article: Article) {
        userImageView.kf.setImage(with: URL(string: article.user.profileImageUrl))
        titleLabel.text = article.title
        userNameLabel.text = article.user.id
        createdAtLabel.text = Date.from(string: article.createdAt).offsetFrom()
        likeCountLabel.text = article.likesCount.description
    }

    // MARK: - Override Methods

    override func prepareForReuse() {
        super.prepareForReuse()

        userImageView.image = nil
        titleLabel.text = ""
        userNameLabel.text = ""
        createdAtLabel.text = ""
        likeCountLabel.text = ""
    }
}
