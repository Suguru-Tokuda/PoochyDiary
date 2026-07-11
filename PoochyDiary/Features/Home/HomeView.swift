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
    struct Model {
        let petName: String
        let statusTitle: String
        let statusDetail: String
        let lastLogText: String
        let weeklyLogs: String
        let normalLogs: String
        let watchItems: String
        let insightTitle: String
        let insightDetail: String

        static func mock(petName: String) -> Model {
            Model(
                petName: petName,
                statusTitle: "Steady this week",
                statusDetail: "Most recent log is normal with no mucus or blood.",
                lastLogText: "Today, 8:45 AM",
                weeklyLogs: "6",
                normalLogs: "4/6",
                watchItems: "1",
                insightTitle: "Keep an eye on one watch item",
                insightDetail: "A small amount of blood appeared once this week. Track the next couple of logs for a pattern."
            )
        }
    }

    weak var delegate: HomeViewDelegate?

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    private let scrollView = UIScrollView()
    private let stackView = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        spacing: Spacing.space16
    )

    private let headerRow = UIStackView(
        axis: .horizontal,
        alignment: .center,
        distribution: .fill,
        spacing: Spacing.space16
    )
    private let headerTextStack = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        spacing: Spacing.space4
    )
    private let eyebrowLabel = HomeView.makeLabel(
        font: .themedFont(.captionEmphasized),
        color: PoochyTheme.secondaryText
    )
    private let titleLabel = HomeView.makeLabel(
        font: .themedFont(.screenTitle),
        color: PoochyTheme.primaryText
    )
    private let subtitleLabel = HomeView.makeLabel(
        font: .themedFont(.body),
        color: PoochyTheme.secondaryText
    )
    private let avatarView = UIView()
    private let avatarIconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "pawprint.fill"))
        imageView.tintColor = PoochyTheme.accent
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let statusCard = UIView()
    private let statusStack = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        spacing: Spacing.space16
    )
    private let statusTopRow = UIStackView(
        axis: .horizontal,
        alignment: .top,
        distribution: .fill,
        spacing: Spacing.space12
    )
    private let statusTextStack = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        spacing: Spacing.space4
    )
    private let statusEyebrowLabel = HomeView.makeLabel(
        text: "CURRENT STATUS",
        font: .themedFont(.pill),
        color: PoochyTheme.secondaryText
    )
    private let statusTitleLabel = HomeView.makeLabel(
        font: .themedFont(.metric),
        color: PoochyTheme.primaryText
    )
    private let statusDetailLabel = HomeView.makeLabel(
        font: .themedFont(.body),
        color: PoochyTheme.secondaryText,
        numberOfLines: 0
    )
    private let statusPill = HomePillView()
    private let lastLogRow = HomeKeyValueRowView()

    let addLogPoopButton: UIButton = {
        let button = UIButton(type: .system)
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = PoochyTheme.accent
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .large
        configuration.image = UIImage(systemName: "plus.circle.fill")
        configuration.imagePadding = Spacing.space8
        configuration.title = "Log new entry"
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: Spacing.space20,
            bottom: 0,
            trailing: Spacing.space20
        )
        button.configuration = configuration
        button.titleLabel?.font = .themedFont(.button)
        return button
    }()

    private let metricsStack = UIStackView(
        axis: .horizontal,
        alignment: .fill,
        distribution: .fillEqually,
        spacing: Spacing.space12
    )
    private let weeklyMetricView = HomeMetricView()
    private let normalMetricView = HomeMetricView()
    private let watchMetricView = HomeMetricView()

    private let insightCard = HomeInsightCardView()
    private let recentLogCard = HomeRecentLogCardView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        applyModel()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func setupUI() {
        backgroundColor = PoochyTheme.background
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false

        addLogPoopButton.addTarget(self, action: #selector(handleAddLogPoopButtonTap), for: .touchUpInside)

        avatarView.backgroundColor = PoochyTheme.accentSoft
        avatarView.layer.cornerRadius = 28
        avatarView.layer.cornerCurve = .continuous
        avatarView.addAutolayoutSubview(avatarIconView)

        headerTextStack.addArrangedSubviews([
            eyebrowLabel,
            titleLabel,
            subtitleLabel
        ])
        headerRow.addArrangedSubviews([
            headerTextStack,
            avatarView
        ])

        statusCard.applyPoochyCardStyle(cornerRadius: 24)
        statusTextStack.addArrangedSubviews([
            statusEyebrowLabel,
            statusTitleLabel,
            statusDetailLabel
        ])
        statusTopRow.addArrangedSubviews([
            statusTextStack,
            statusPill
        ])
        statusStack.addArrangedSubviews([
            statusTopRow,
            lastLogRow,
            addLogPoopButton
        ])
        statusCard.addAutolayoutSubview(statusStack)

        metricsStack.addArrangedSubviews([
            weeklyMetricView,
            normalMetricView,
            watchMetricView
        ])

        stackView.addArrangedSubviews([
            headerRow,
            statusCard,
            metricsStack,
            insightCard,
            recentLogCard
        ])
        stackView.setCustomSpacing(Spacing.space24, after: headerRow)

        scrollView.addAutolayoutSubview(stackView)
        addAutolayoutSubview(scrollView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: Spacing.space24),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -Spacing.space32),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Spacing.space20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -Spacing.space20),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -Spacing.space40),

            avatarView.heightAnchor.constraint(equalToConstant: 56),
            avatarView.widthAnchor.constraint(equalTo: avatarView.heightAnchor),
            avatarIconView.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarIconView.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            avatarIconView.heightAnchor.constraint(equalToConstant: 26),
            avatarIconView.widthAnchor.constraint(equalTo: avatarIconView.heightAnchor),

            statusStack.topAnchor.constraint(equalTo: statusCard.topAnchor, constant: Spacing.space20),
            statusStack.bottomAnchor.constraint(equalTo: statusCard.bottomAnchor, constant: -Spacing.space20),
            statusStack.leadingAnchor.constraint(equalTo: statusCard.leadingAnchor, constant: Spacing.space20),
            statusStack.trailingAnchor.constraint(equalTo: statusCard.trailingAnchor, constant: -Spacing.space20),

            addLogPoopButton.heightAnchor.constraint(equalToConstant: 52),
            weeklyMetricView.heightAnchor.constraint(equalToConstant: 112),
            normalMetricView.heightAnchor.constraint(equalTo: weeklyMetricView.heightAnchor),
            watchMetricView.heightAnchor.constraint(equalTo: weeklyMetricView.heightAnchor)
        ])
    }

    private func applyModel() {
        let model = model ?? .mock(petName: "Leo")

        eyebrowLabel.text = "POOCHY DIARY"
        titleLabel.text = "\(model.petName)'s health log"
        subtitleLabel.text = "A calm overview before the next walk."

        statusTitleLabel.text = model.statusTitle
        statusDetailLabel.text = model.statusDetail
        statusPill.configure(text: "On track", systemImageName: "checkmark.circle.fill", tintColor: PoochyTheme.accent)
        lastLogRow.configure(
            title: "Last log",
            value: model.lastLogText,
            systemImageName: "clock.fill"
        )

        weeklyMetricView.configure(value: model.weeklyLogs, title: "Logs", caption: "past 7 days")
        normalMetricView.configure(value: model.normalLogs, title: "Normal", caption: "healthy signs")
        watchMetricView.configure(
            value: model.watchItems,
            title: "Watch",
            caption: "needs review",
            valueColor: PoochyTheme.attention
        )

        insightCard.configure(title: model.insightTitle, detail: model.insightDetail)
        recentLogCard.configure(timeText: model.lastLogText, stoolText: "Normal", mucusText: "None", bloodText: "None")
    }

    @objc private func handleAddLogPoopButtonTap() {
        delegate?.onAddLogPoopButtonTapped()
    }

    private static func makeLabel(
        text: String? = nil,
        font: UIFont,
        color: UIColor,
        numberOfLines: Int = 1
    ) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = color
        label.numberOfLines = numberOfLines
        label.adjustsFontForContentSizeCategory = true
        return label
    }
}

private final class HomeMetricView: BaseView {
    private let stackView = UIStackView(
        axis: .vertical,
        alignment: .leading,
        distribution: .fill,
        spacing: Spacing.space4
    )
    private let valueLabel = UILabel()
    private let titleLabel = UILabel()
    private let captionLabel = UILabel()

    override func constructView() {
        super.constructView()
        applyPoochyCardStyle(cornerRadius: 18)
    }

    override func constructSubviews() {
        super.constructSubviews()

        valueLabel.font = .themedFont(.metric)
        valueLabel.textColor = PoochyTheme.primaryText
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.8

        titleLabel.font = .themedFont(.captionEmphasized)
        titleLabel.textColor = PoochyTheme.primaryText

        captionLabel.font = .themedFont(.caption)
        captionLabel.textColor = PoochyTheme.secondaryText
        captionLabel.numberOfLines = 2

        stackView.addArrangedSubviews([
            valueLabel,
            titleLabel,
            captionLabel
        ])
        addAutolayoutSubview(stackView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.space16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -Spacing.space16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.space12)
        ])
    }

    func configure(value: String, title: String, caption: String, valueColor: UIColor = PoochyTheme.primaryText) {
        valueLabel.text = value
        valueLabel.textColor = valueColor
        titleLabel.text = title
        captionLabel.text = caption
    }
}

private final class HomePillView: BaseView {
    private let stackView = UIStackView(
        axis: .horizontal,
        alignment: .center,
        distribution: .fill,
        spacing: Spacing.space4
    )
    private let imageView = UIImageView()
    private let label = UILabel()

    override func constructView() {
        super.constructView()
        backgroundColor = PoochyTheme.accentSoft
        layer.cornerRadius = 14
        layer.cornerCurve = .continuous
    }

    override func constructSubviews() {
        super.constructSubviews()

        label.font = .themedFont(.pill)
        label.textColor = PoochyTheme.accent

        imageView.contentMode = .scaleAspectFit

        stackView.addArrangedSubviews([
            imageView,
            label
        ])
        addAutolayoutSubview(stackView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.space8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.space8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.space10),
            imageView.heightAnchor.constraint(equalToConstant: 14),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }

    func configure(text: String, systemImageName: String, tintColor: UIColor) {
        label.text = text
        label.textColor = tintColor
        imageView.image = UIImage(systemName: systemImageName)
        imageView.tintColor = tintColor
    }
}

private final class HomeKeyValueRowView: BaseView {
    private let stackView = UIStackView(
        axis: .horizontal,
        alignment: .center,
        distribution: .fill,
        spacing: Spacing.space12
    )
    private let iconContainer = UIView()
    private let imageView = UIImageView()
    private let textStack = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        spacing: Spacing.space2
    )
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()

    override func constructView() {
        super.constructView()
        backgroundColor = PoochyTheme.elevatedSurface
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
    }

    override func constructSubviews() {
        super.constructSubviews()

        iconContainer.backgroundColor = PoochyTheme.surface
        iconContainer.layer.cornerRadius = 18
        iconContainer.layer.cornerCurve = .continuous

        imageView.tintColor = PoochyTheme.accent
        imageView.contentMode = .scaleAspectFit

        titleLabel.font = .themedFont(.pill)
        titleLabel.textColor = PoochyTheme.secondaryText

        valueLabel.font = .themedFont(.bodyEmphasized)
        valueLabel.textColor = PoochyTheme.primaryText

        iconContainer.addAutolayoutSubview(imageView)
        textStack.addArrangedSubviews([
            titleLabel,
            valueLabel
        ])
        stackView.addArrangedSubviews([
            iconContainer,
            textStack
        ])
        addAutolayoutSubview(stackView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.space12),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.space12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.space12),

            iconContainer.heightAnchor.constraint(equalToConstant: 36),
            iconContainer.widthAnchor.constraint(equalTo: iconContainer.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 16),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }

    func configure(title: String, value: String, systemImageName: String) {
        titleLabel.text = title
        valueLabel.text = value
        imageView.image = UIImage(systemName: systemImageName)
    }
}

private final class HomeInsightCardView: BaseView {
    private let stackView = UIStackView(
        axis: .horizontal,
        alignment: .top,
        distribution: .fill,
        spacing: Spacing.space12
    )
    private let iconContainer = UIView()
    private let imageView = UIImageView(image: UIImage(systemName: "waveform.path.ecg"))
    private let textStack = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        spacing: Spacing.space4
    )
    private let titleLabel = UILabel()
    private let detailLabel = UILabel()

    override func constructView() {
        super.constructView()
        applyPoochyCardStyle(cornerRadius: 18)
    }

    override func constructSubviews() {
        super.constructSubviews()

        iconContainer.backgroundColor = PoochyTheme.attention.withAlphaComponent(0.14)
        iconContainer.layer.cornerRadius = 18
        iconContainer.layer.cornerCurve = .continuous

        imageView.tintColor = PoochyTheme.attention
        imageView.contentMode = .scaleAspectFit

        titleLabel.font = .themedFont(.cardTitle)
        titleLabel.textColor = PoochyTheme.primaryText
        titleLabel.numberOfLines = 0

        detailLabel.font = .themedFont(.body)
        detailLabel.textColor = PoochyTheme.secondaryText
        detailLabel.numberOfLines = 0

        iconContainer.addAutolayoutSubview(imageView)
        textStack.addArrangedSubviews([
            titleLabel,
            detailLabel
        ])
        stackView.addArrangedSubviews([
            iconContainer,
            textStack
        ])
        addAutolayoutSubview(stackView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.space16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.space16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.space16),

            iconContainer.heightAnchor.constraint(equalToConstant: 36),
            iconContainer.widthAnchor.constraint(equalTo: iconContainer.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 18),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }

    func configure(title: String, detail: String) {
        titleLabel.text = title
        detailLabel.text = detail
    }
}

private final class HomeRecentLogCardView: BaseView {
    private let stackView = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        spacing: Spacing.space12
    )
    private let titleRow = UIStackView(
        axis: .horizontal,
        alignment: .center,
        distribution: .fill,
        spacing: Spacing.space8
    )
    private let titleLabel = UILabel()
    private let timeLabel = UILabel()
    private let chipStack = UIStackView(
        axis: .horizontal,
        alignment: .fill,
        distribution: .fillEqually,
        spacing: Spacing.space8
    )
    private let stoolChip = HomeStatusChipView()
    private let mucusChip = HomeStatusChipView()
    private let bloodChip = HomeStatusChipView()

    override func constructView() {
        super.constructView()
        applyPoochyCardStyle(cornerRadius: 18)
    }

    override func constructSubviews() {
        super.constructSubviews()

        titleLabel.text = "Recent log"
        titleLabel.font = .themedFont(.cardTitle)
        titleLabel.textColor = PoochyTheme.primaryText

        timeLabel.font = .themedFont(.captionEmphasized)
        timeLabel.textColor = PoochyTheme.secondaryText
        timeLabel.textAlignment = .right

        titleRow.addArrangedSubviews([
            titleLabel,
            timeLabel
        ])
        chipStack.addArrangedSubviews([
            stoolChip,
            mucusChip,
            bloodChip
        ])
        stackView.addArrangedSubviews([
            titleRow,
            chipStack
        ])
        addAutolayoutSubview(stackView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.space16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.space16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.space16),
            stoolChip.heightAnchor.constraint(equalToConstant: 64)
        ])
    }

    func configure(timeText: String, stoolText: String, mucusText: String, bloodText: String) {
        timeLabel.text = timeText
        stoolChip.configure(title: "Stool", value: stoolText, systemImageName: "circle.hexagongrid.fill")
        mucusChip.configure(title: "Mucus", value: mucusText, systemImageName: "drop.fill")
        bloodChip.configure(title: "Blood", value: bloodText, systemImageName: "heart.fill")
    }
}

private final class HomeStatusChipView: BaseView {
    private let stackView = UIStackView(
        axis: .vertical,
        alignment: .leading,
        distribution: .fill,
        spacing: Spacing.space2
    )
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()

    override func constructView() {
        super.constructView()
        backgroundColor = PoochyTheme.elevatedSurface
        layer.cornerRadius = 14
        layer.cornerCurve = .continuous
    }

    override func constructSubviews() {
        super.constructSubviews()

        imageView.tintColor = PoochyTheme.accent
        imageView.contentMode = .scaleAspectFit

        titleLabel.font = .themedFont(.caption)
        titleLabel.textColor = PoochyTheme.secondaryText

        valueLabel.font = .themedFont(.captionEmphasized)
        valueLabel.textColor = PoochyTheme.primaryText
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.8

        stackView.addArrangedSubviews([
            imageView,
            titleLabel,
            valueLabel
        ])
        addAutolayoutSubview(stackView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.space10),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -Spacing.space10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.space10),
            imageView.heightAnchor.constraint(equalToConstant: 14),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }

    func configure(title: String, value: String, systemImageName: String) {
        titleLabel.text = title
        valueLabel.text = value
        imageView.image = UIImage(systemName: systemImageName)
    }
}
