//
//  TagSelectionView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/17/26.
//

import UIKit

class TagSelectionView: BaseView {

    // MARK: - Closures

    var onDone: (() -> Void)?
    var onCancel: (() -> Void)?
    var onSelectTag: ((Tag) -> Void)?
    var onDeselectTag: ((Tag) -> Void)?
    var onSearchTextChange: ((String?) -> Void)?
    var onCreateNewTag: (() -> Void)?

    // MARK: - UI Components

    private let scrollView = UIScrollView()
    private let stackView = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        spacing: Spacing.space12
    )
    private let headerStackView = UIStackView(
        axis: .vertical, alignment: .center, distribution: .fillEqually)
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.sectionTitle)
        label.text = "Tags"
        return label
    }()
    private let subTitles: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.caption)
        label.textColor = PoochyTheme.secondaryText
        label.text = "Add diet, medication, symptoms or custom tags."
        return label
    }()
    private let newTagSectionView: NewTagSectionView = {
        let newTagSectionView = NewTagSectionView()
        newTagSectionView.isHidden = true
        return newTagSectionView
    }()
    private let selectedTagsView = SelectedTagsView()
    private let tagOptionsView = TagOptionsView()
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = PoochyTheme.outline.cgColor
        textField.layer.cornerRadius = 8
        textField.backgroundColor = PoochyTheme.elevatedSurface

        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = PoochyTheme.secondaryText
        imageView.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
        imageView.contentMode = .scaleAspectFit

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        paddingView.addSubview(imageView)

        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.returnKeyType = .continue
        textField.placeholder = "Search or create tag..."
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.smartInsertDeleteType = .no
        textField.smartQuotesType = .no
        textField.smartDashesType = .no
        textField.autocapitalizationType = .none

        return textField
    }()

    private let actionBarView = ActionBarView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubscriptions()
    }

    @MainActor required init?(coder: NSCoder) {
        nil
    }

    override func constructSubviews() {
        super.constructSubviews()
        scrollView.addAutolayoutSubview(stackView)
        headerStackView.addArrangedSubviews([
            titleLabel,
            subTitles
        ])
        stackView.addArrangedSubviews([
            headerStackView,
            searchTextField,
            newTagSectionView,
            selectedTagsView,
            tagOptionsView
        ])
        addAutolayoutSubviews([
            scrollView,
            actionBarView
        ])
        searchTextField.delegate = self

        actionBarView.onDone = { [weak self] in
            self?.onDone?()
        }

        actionBarView.onCancel = { [weak self] in
            self?.onCancel?()
        }
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: actionBarView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            actionBarView.bottomAnchor.constraint(equalTo: bottomAnchor),
            actionBarView.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: Spacing.space24),
            actionBarView.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -Spacing.space24),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -Spacing.space24),
            stackView.leadingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Spacing.space24),
            stackView.trailingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -Spacing.space24),

            searchTextField.heightAnchor.constraint(equalToConstant: Spacing.space40),
            actionBarView.heightAnchor.constraint(equalToConstant: Spacing.space48),

            stackView.widthAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -Spacing.space48)
        ])
    }

    func configure(selectedTags: [Tag], tagOptions: [Tag]) {
        selectedTagsView.isHidden = selectedTags.isEmpty
        selectedTagsView.model = SelectedTagsView.Model(tags: selectedTags)
        tagOptionsView.isHidden = tagOptions.isEmpty
        tagOptionsView.model = TagOptionsView.Model(tags: tagOptions)
    }

    func configure(tag: String) {
        guard !tag.isEmpty else {
            newTagSectionView.isHidden = true
            return
        }
        newTagSectionView.model = NewTagSectionView.Model(newTag: tag)
        newTagSectionView.isHidden = false
    }

    func configure(searchText: String) {
        searchTextField.text = searchText
    }

    private func addSubscriptions() {
        tagOptionsView.onSelectTag = { [weak self] selectedTag in
            self?.onSelectTag?(selectedTag)
        }

        selectedTagsView.onRemoveTag = { [weak self] deselectedTag in
            self?.onDeselectTag?(deselectedTag)
        }

        newTagSectionView.onCreateButtonTap = { [weak self] in
            self?.onCreateNewTag?()
        }
    }
}

extension TagSelectionView: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersInRanges ranges: [NSValue],
        replacementString string: String
    ) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }

        let currentText = textField.text ?? ""

        guard let rangeValue = ranges.first?.rangeValue,
            let textRange = Range(rangeValue, in: currentText)
        else {
            return true
        }

        let updatedText = currentText.replacingCharacters(in: textRange, with: string)

        onSearchTextChange?(updatedText)

        return true
    }
}
