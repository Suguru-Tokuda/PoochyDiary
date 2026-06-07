//
//  PoopHistorySectionHeaderView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 6/1/26.
//

import UIKit

class PoopHistorySectionHeaderView: BaseCollectionReusableView {
    struct Model {
        let date: Date
    }

    class var reuseIdentifier: String {
        "PoopHistorySectionHeaderView"
    }

    private let stackView = UIStackView(
        axis: .horizontal,
        alignment: .leading,
        distribution: .fill,
        spacing: 2
    )
    private let calendarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "calendar"))
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    override func constructSubviews() {
        super.constructSubviews()
        stackView.addArrangedSubviews([
            calendarImageView,
            dateLabel
        ])

        addAutolayoutSubview(stackView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),

            calendarImageView.widthAnchor.constraint(equalToConstant: 16),
            calendarImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }

    private func applyModel() {
        guard let model else { return }

        let date = model.date

        if Calendar.current.isDateInToday(date) {
            dateLabel.textColor = .accent
            calendarImageView.tintColor = .accent
            dateLabel.text = "\(Strings.LogPoop.today) • "
        } else if Calendar.current.isDateInYesterday(date) {
            dateLabel.text = "\(Strings.LogPoop.yesterday) • "
        }

        dateLabel.text = "\(dateLabel.text ?? "")\(date.formatted(with: "MMM d, YYYY"))"
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        dateLabel.textColor = .secondaryLabel
        calendarImageView.tintColor = .secondaryLabel
    }
}
