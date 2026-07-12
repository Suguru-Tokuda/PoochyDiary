//
//  TagSelectionViewController.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/17/26.
//

import Combine
import UIKit

class TagSelectionViewController: BaseViewController {
    var onCancelButtonTap: (() -> Void)?
    var onDoneButtonTap: (([Tag]) -> Void)?

    private let tagSelectionView = TagSelectionView()
    private let viewModel: TagSelectionViewModel
    private var subscriptions = Set<AnyCancellable>()

    init(viewModel: TagSelectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @MainActor deinit {
        subscriptions.removeAll()
    }

    @MainActor required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubscriptions()
    }

    override func constructSubviews() {
        super.constructSubviews()
        view.addAutolayoutSubview(tagSelectionView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            tagSelectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Spacing.space24),
            tagSelectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tagSelectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tagSelectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func addSubscriptions() {
        tagSelectionView.onSearchTextChange = { [weak self] searchText in
            self?.viewModel.searchText = searchText
        }

        tagSelectionView.onDone = { [weak self] in
            guard let self else {
                return
            }
            onDoneButtonTap?(viewModel.selectedTags)
        }

        tagSelectionView.onCancel = { [weak self] in
            self?.onCancelButtonTap?()
        }

        tagSelectionView.onSelectTag = { [weak self] selectedTag in
            self?.viewModel.selectTag(tag: selectedTag)
        }

        tagSelectionView.onDeselectTag = { [weak self] deselectedTag in
            self?.viewModel.deselectTag(tag: deselectedTag)
        }

        tagSelectionView.onCreateNewTag = { [weak self] in
            self?.viewModel.createNewTag()
        }

        viewModel
            .filteredTagOptionsPublisher
            .combineLatest(viewModel.selectedTagOptionsPublisher)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                guard let self else { return }
                let filteredOptions = output.0
                let selectedTags = output.1
                tagSelectionView.configure(selectedTags: selectedTags, tagOptions: filteredOptions)
            }
            .store(in: &subscriptions)

        viewModel
            .newTagPublisher
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newTag in
                guard let self else { return }
                tagSelectionView.configure(tag: newTag)
            }
            .store(in: &subscriptions)

        viewModel
            .$searchText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] searchText in
                guard let self else { return }

                tagSelectionView.configure(searchText: searchText ?? "")
            }
            .store(in: &subscriptions)
    }
}
