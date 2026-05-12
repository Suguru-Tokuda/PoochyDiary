//
//  NotesView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/8/26.
//

import UIKit

class NotesView: BaseView {

    var onTextChange: ((String) -> Void)?

    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let borderWidth: CGFloat = 1
        static let padding: CGFloat = 12
    }

    // MARK: UI Components

    private let titleLabel: PDLabel = {
        let label = PDLabel()
        label.model = PDLabel.Model(title: "Notes", isOptional: true)
        return label
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.borderWidth = Constants.borderWidth
        view.layer.borderColor = UIColor.systemGray5.cgColor
        return view
    }()

    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Add any notes about this poop..."
        label.textColor = .placeholderText
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    override func constructSubviews() {
        super.constructSubviews()
        textView.delegate = self

        addAutolayoutSubviews([
            titleLabel,
            containerView
        ])

        containerView.addAutolayoutSubviews([
            textView,
            placeholderLabel
        ])
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),

            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 120),

            textView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.padding),
            textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.padding),
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.padding),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.padding),

            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor),
        ])
    }
}

extension NotesView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        onTextChange?(textView.text)
    }
}
