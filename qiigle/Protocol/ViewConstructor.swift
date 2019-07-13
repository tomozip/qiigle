//
//  ViewConstructor.swift
//  OnaChat
//
//  Created by 島田智貴 on 2019/05/08.
//  Copyright © 2019 Tomozip. All rights reserved.
//

// If you want to set up view and subviews in UIViewController or UIVIew,
// You have to conform this protocol and #setupViews and #setupViewConstraints
// must be called in the appropriate method in the proper order.
//
// The conformed methods #setupViews and #setupViewConstraints
// must be called in the below order:
//
// If UIViewController conforms this protcol:
//
// ```
// override func viewDidLoad() {
//     super.viewDidLoad()
//     setupViews()
//     setupViewConstraints()
//     setupButtons()
//     setupGestureRecognizers()
// }
// ```
//
// If UIView conforms this protocol:
//
// ```
// override init() {
//     super.init()
//     setupViews()
//     setupViewConstraints()
//     setupButtons()
//     setupGestureRecognizers()
// }
// ```
//
protocol ViewConstructor: AnyObject {
    // #setupViews sets properties of views and adds subviews
    //
    // Example:
    //
    // ```
    // func setupViews() {
    //     view.backgroundColor = .white
    //     view.addSubview(fooView)
    // }
    // ```
    //
    func setupViews()

    // #setupViewConstraints makes constraints using SnapKit.
    //
    // Example:
    //
    // ```
    // func setupConstraints() {
    //     view.snp.makeConstraints {
    //         $0.edges.equalToSuperview()
    //     }
    //     fooView.snp.makeConstraints {
    //         $0.edges.equalToSuperview()
    //     }
    // }
    // ```
    //
    func setupViewConstraints()

    // #setupButtons sets functions of buttons when tapped
    //
    // Example:
    //
    // ```
    // func setupButtons() {
    //     hogeButton.rx.tap
    //         .bind { [weak self] _ in
    //             self?.callback?.didTapHoge()
    //         }
    //         .disposed(by: disposeBag)
    // }
    // ```
    //
    func setupButtons()

    // #setupGestureRecognizers sets functions when gesture is recognized
    //
    // Example:
    //
    // ```
    // func setupGestureRecognizers() {
    //     hogeView.rx.tapGesture()
    //         .when(.recognized)
    //         .bind { [weak self] _ in
    //             self?.textView.resignFirstResponder()
    //         }
    //         .disposed(by: disposeBag)
    //
    //     scrollView.panGestureRecognizer.rx.event
    //         .bind { [weak self] _ in
    //             self?.closeKeyboard()
    //         }
    //         .disposed(by: disposeBag)
    // }
    // ```
    //
    func setupGestureRecognizers()
}
