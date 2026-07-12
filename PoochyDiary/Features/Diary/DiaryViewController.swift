//
//  DiaryViewController.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import Combine
import UIKit

protocol DiaryViewControllerDelegate: AnyObject {
    func onAddButtonTap()
    func onFilterButtonTap()
}

final class DiaryViewController: BaseViewController {
    weak var delegate: DiaryViewControllerDelegate?

    private let viewModel: DiaryViewModel
    private var subscriptions = Set<AnyCancellable>()

    // MARK: UI Components

    private let diaryView = DiaryView()

    init(viewModel: DiaryViewModel, onDiarySelect: ((Diary) -> Void)?) {
        self.viewModel = viewModel
        diaryView.onDiarySelect = onDiarySelect
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubscriptions()
    }

    override func constructView() {
        super.constructView()
        view.backgroundColor = PoochyTheme.background
    }

    override func constructSubviews() {
        super.constructSubviews()

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "plus"),
                style: .plain,
                target: self,
                action: #selector(handleAddButtonTap)
            ),
            UIBarButtonItem(
                image: UIImage(systemName: "line.3.horizontal.decrease"),
                style: .plain,
                target: self,
                action: #selector(handleFilterButtonTap))
        ]

        view.addAutolayoutSubview(diaryView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            diaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            diaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space16),
            diaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space16)
        ])
    }

    private func addSubscriptions() {
        viewModel
            .$visibleWeekDate
            .combineLatest(viewModel.$displayedDates, viewModel.$diaries)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self else { return }

                let visibleWeekDate = value.0
                let displayedDates = value.1
                let diaries = value.2
                let selectedDateDiaries = diaries.filter {
                    Calendar.current.isDate($0.date, inSameDayAs: visibleWeekDate)
                }

                let headerModel = DateFilterHeaderView.Model(
                    date: visibleWeekDate
                )
                let dateModels = displayedDates.map { displayedDate in
                    DateFilterCollectionViewCell.Model(
                        date: displayedDate.date,
                        day: Days(date: displayedDate.date),
                        hasDiary: displayedDate.hasDiary,
                        isSelected: displayedDate.isSelected
                    )
                }

                diaryView.model = DiaryView.Model(
                    dateFilterModel: DateFilterCollectionView.Model(
                        headerModel: headerModel,
                        items: dateModels
                    ),
                    items: selectedDateDiaries
                )
            }
            .store(in: &subscriptions)

        diaryView.onWeekChange = { [weak self] offset in
            self?.viewModel.moveVisibleWeek(by: offset)
        }

        diaryView.onDateSelect = { [weak self] date in
            self?.viewModel.selectDate(date)
        }
    }

    @objc private func handleAddButtonTap() {
        delegate?.onAddButtonTap()
    }

    @objc private func handleFilterButtonTap() {
        delegate?.onFilterButtonTap()
    }
}
