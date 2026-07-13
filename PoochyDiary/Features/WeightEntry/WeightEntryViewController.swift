//
//  WeightEntryViewController.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/13/26.
//

import UIKit

final class WeightEntryViewController: BaseViewController {
    var onSave: ((Diary) -> Void)?
    var onCancel: (() -> Void)?

    private let viewModel: WeightEntryViewModel
    private let weightEntryView = WeightEntryView()

    init(viewModel: WeightEntryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func constructView() {
        super.constructView()
        view.backgroundColor = PoochyTheme.background
    }

    override func constructSubviews() {
        super.constructSubviews()
        addBindings()
        view.addAutolayoutSubview(weightEntryView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            weightEntryView.topAnchor.constraint(equalTo: view.topAnchor),
            weightEntryView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            weightEntryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weightEntryView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func addBindings() {
        weightEntryView.onWeightChange = { [weak self] text in
            self?.viewModel.updateWeight(text)
        }
        weightEntryView.onUnitChange = { [weak self] unit in
            self?.viewModel.updateUnit(unit)
        }
        weightEntryView.onDateChange = { [weak self] date in
            self?.viewModel.updateDate(date)
        }
        weightEntryView.onCancelButtonTap = { [weak self] in
            self?.onCancel?()
        }
        weightEntryView.onSaveButtonTap = { [weak self] in
            self?.save()
        }
    }

    private func save() {
        weightEntryView.setSaving(true)
        Task { [weak self] in
            guard let self else { return }

            do {
                let diary = try await viewModel.save()
                onSave?(diary)
            } catch WeightEntryError.invalidWeight {
                weightEntryView.showError(Strings.WeightEntry.invalidWeight)
                weightEntryView.setSaving(false)
            } catch {
                weightEntryView.showError(Strings.WeightEntry.saveFailed)
                weightEntryView.setSaving(false)
            }
        }
    }
}
