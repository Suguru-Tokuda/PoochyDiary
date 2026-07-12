//
//  DiaryEntryFormBaseView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/22/26.
//

import UIKit

class DiaryEntryFormBaseView: BaseView {
    private(set) var errorMessageView = PDErrorMessageView(isHidden: true)

    func setErrorMessage(_ errorMessage: String?) {
        guard let errorMessage else {
            errorMessageView.isHidden = true
            return
        }

        errorMessageView.setErrorMessage(errorMessage)
    }
}
