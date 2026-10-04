//
//  TrendTimeFramesView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 10/1/26.
//

import UIKit

class TrendTimeFramesView: BaseView {
    enum TimeFrame: Int, CaseIterable {
        case week = 7
        case month = 30
        case quarter = 90

        var title: String { "\(rawValue) days"}
    }

    var onTimeFrameSelect: ((TimeFrame) -> Void)?
    private let timeFrames = TimeFrame.allCases

    var model: TimeFrame? {
        didSet {
            applyModel()
        }
    }

    private lazy var timeFrameControl: UISegmentedControl = {
        let control = UISegmentedControl(
            items: timeFrames.map(\.title)
        )

        control.selectedSegmentIndex = 0
        control.selectedSegmentTintColor = PoochyTheme.accent
        control.backgroundColor = PoochyTheme.background

        let font = UIFont.themedFont(.cardTitle)

        control.setTitleTextAttributes([
            .font: font,
            .foregroundColor: PoochyTheme.primaryText
        ], for: .normal)

        control.setTitleTextAttributes([
            .font: font,
            .foregroundColor: PoochyTheme.white
        ], for: .selected)

        control.addTarget(
            self,
            action: #selector(timeFrameChanged(_:)),
            for: .valueChanged
        )

        return control
    }()

    override func constructSubviews() {
        super.constructSubviews()
        addAutolayoutSubview(timeFrameControl)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            timeFrameControl.topAnchor.constraint(equalTo: topAnchor),
            timeFrameControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            timeFrameControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            timeFrameControl.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    @objc private func timeFrameChanged(_ sender: UISegmentedControl) {
        guard timeFrames.indices.contains(sender.selectedSegmentIndex) else {
            return
        }

        let timeFrame = timeFrames[sender.selectedSegmentIndex]
        onTimeFrameSelect?(timeFrame)
    }

    private func applyModel() {
        guard let model,
              let index = TimeFrame.allCases.firstIndex(where: { $0 == model }) else { return }

        timeFrameControl.selectedSegmentIndex = index
    }
}
