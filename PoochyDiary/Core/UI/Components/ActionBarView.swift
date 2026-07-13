//
//  ActionBarView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/20/26.
//

import UIKit

class ActionBarView: BaseView {

    // MARK: - Closures

    var onDone: (() -> Void)?
    var onCancel: (() -> Void)?

    // MARK: - UI Components

    private let buttonStackView = UIStackView(
        axis: .horizontal,
        alignment: .fill,
        distribution: .fillEqually,
        spacing: Spacing.space8
    )

    private let doneButton: PDButton = {
        let button = PDButton()
        button.setTitle(Strings.Common.done, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .accent
        return button
    }()

    private let cancelButton: PDButton = {
        let button = PDButton()
        button.setTitle(Strings.Common.cancel, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = PoochyTheme.secondaryText
        return button
    }()

    override func constructSubviews() {
        super.constructSubviews()
        buttonStackView.addArrangedSubviews([
            cancelButton,
            doneButton
        ])
        addAutolayoutSubview(buttonStackView)
        cancelButton.addTarget(
            self,
            action: #selector(handleCancelButtonTap),
            for: .touchUpInside
        )
        doneButton.addTarget(
            self,
            action: #selector(handleDoneButtonTap),
            for: .touchUpInside
        )
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: topAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension ActionBarView {
    @objc private func handleDoneButtonTap() {
        onDone?()
    }

    @objc private func handleCancelButtonTap() {
        onCancel?()
    }
}
