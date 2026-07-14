//
//  DiaryViewController.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import Combine
import UIKit

protocol DiaryViewControllerDelegate: AnyObject {
    func diaryViewController(
        _ viewController: DiaryViewController,
        didSelectTrackingOption option: DiaryTrackingOption
    )
    func diaryViewController(
        _ viewController: DiaryViewController,
        didRequestDateSelectionFrom selectedDate: Date
    )
}

final class DiaryViewController: BaseViewController {
    weak var delegate: DiaryViewControllerDelegate?
    var onPetSelectorTap: (() -> Void)?

    private let viewModel: DiaryViewModel
    private var subscriptions = Set<AnyCancellable>()

    // MARK: UI Components

    private let headerView = DiaryHeaderView()
    private let diaryView = DiaryView()

    init(
        viewModel: DiaryViewModel,
        petName: String,
        onDiarySelect: ((Diary) -> Void)?
    ) {
        self.viewModel = viewModel
        headerView.petName = petName
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

        headerView.onTrackingOptionSelect = { [weak self] option in
            guard let self else { return }
            delegate?.diaryViewController(self, didSelectTrackingOption: option)
        }
        headerView.onPetSelectorTap = { [weak self] in
            self?.onPetSelectorTap?()
        }
        headerView.onCalendarButtonTap = { [weak self] in
            self?.handleCalendarButtonTap()
        }
        view.addAutolayoutSubview(headerView)
        view.addAutolayoutSubview(diaryView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Spacing.space16
            ),
            headerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Spacing.space16
            ),
            diaryView.topAnchor.constraint(
                equalTo: headerView.bottomAnchor,
                constant: Spacing.space16
            ),
            diaryView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            diaryView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Spacing.space16),
            diaryView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -Spacing.space16)
        ])
    }

    private func addSubscriptions() {
        viewModel
            .$visibleWeekDate
            .combineLatest(
                viewModel.$displayedDates,
                viewModel.$diaries,
                viewModel.$weightUnit
            )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self else { return }

                let visibleWeekDate = value.0
                let displayedDates = value.1
                let diaries = value.2
                let weightUnit = value.3
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
                    items: selectedDateDiaries,
                    weightUnit: weightUnit
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

    private func handleCalendarButtonTap() {
        delegate?.diaryViewController(
            self,
            didRequestDateSelectionFrom: viewModel.visibleWeekDate
        )
    }

    func selectDate(_ date: Date) {
        viewModel.selectDate(date)
    }

    func updatePet(_ pet: Pet) {
        headerView.petName = pet.name
    }

    func addDiary(_ diary: Diary) {
        viewModel.addDiary(diary)
    }
}

extension DiaryViewController: NavigationBarConfigurable {
    var prefersNavigationBarHidden: Bool {
        true
    }
}
