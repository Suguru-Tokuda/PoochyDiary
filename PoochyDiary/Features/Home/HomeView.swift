//
//  HomeView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/10/26.
//

import UIKit

protocol HomeViewDelegate: AnyObject {
    func onAddLogPoopButtonTapped()
}

class HomeView: UIView {
    weak var delegate: HomeViewDelegate?

    let scrollView = UIScrollView()
    let stackView = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        spacing: 8
    )
    let addLogPoopButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Log Poop", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        nil
    }

    private func setupUI() {
        addLogPoopButton.addTarget(self, action: #selector(handleAddLogPoopButtonTap), for: .touchUpInside)
        scrollView.addAutolayoutSubview(stackView)
        stackView.addArrangedSubviews([
            addLogPoopButton
        ])
        addAutolayoutSubview(scrollView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 24),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -24),

            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -48),

            addLogPoopButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    @objc private func handleAddLogPoopButtonTap() {
        delegate?.onAddLogPoopButtonTapped()
    }
}
