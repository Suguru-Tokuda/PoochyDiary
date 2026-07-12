//
//  PoochyTypography.swift
//  PoochyDiary
//
//  Created by Codex on 7/10/26.
//

import UIKit

enum PoochyFontStyle: CaseIterable {
    case heroTitle
    case screenTitle
    case sectionTitle
    case cardTitle
    case body
    case bodyEmphasized
    case caption
    case captionEmphasized
    case pill
    case button
    case metric

    var pointSize: CGFloat {
        switch self {
        case .heroTitle:
            return 32
        case .screenTitle:
            return 30
        case .sectionTitle:
            return 22
        case .cardTitle:
            return 16
        case .body:
            return 15
        case .bodyEmphasized:
            return 15
        case .caption:
            return 13
        case .captionEmphasized:
            return 13
        case .pill:
            return 12
        case .button:
            return 16
        case .metric:
            return 24
        }
    }

    var weight: UIFont.Weight {
        switch self {
        case .heroTitle, .screenTitle, .sectionTitle, .cardTitle, .metric, .pill:
            return .bold
        case .bodyEmphasized, .captionEmphasized, .button:
            return .semibold
        case .body, .caption:
            return .regular
        }
    }

    var textStyle: UIFont.TextStyle {
        switch self {
        case .heroTitle:
            return .largeTitle
        case .screenTitle:
            return .title1
        case .sectionTitle:
            return .title3
        case .cardTitle, .button, .metric:
            return .headline
        case .body, .bodyEmphasized:
            return .body
        case .caption, .captionEmphasized, .pill:
            return .caption1
        }
    }

    var displayName: String {
        switch self {
        case .heroTitle:
            return "Hero Title"
        case .screenTitle:
            return "Screen Title"
        case .sectionTitle:
            return "Section Title"
        case .cardTitle:
            return "Card Title"
        case .body:
            return "Body"
        case .bodyEmphasized:
            return "Body Emphasized"
        case .caption:
            return "Caption"
        case .captionEmphasized:
            return "Caption Emphasized"
        case .pill:
            return "Pill"
        case .button:
            return "Button"
        case .metric:
            return "Metric"
        }
    }

    var usage: String {
        switch self {
        case .heroTitle:
            return "Primary status or detail titles."
        case .screenTitle:
            return "Top-level page titles."
        case .sectionTitle:
            return "Section headers such as Photos or Health Signals."
        case .cardTitle:
            return "Compact card headings and smaller modules."
        case .body:
            return "Paragraphs, notes, and normal descriptive text."
        case .bodyEmphasized:
            return "Important body values and short field values."
        case .caption:
            return "Secondary timestamps and helper labels."
        case .captionEmphasized:
            return "Small metadata with extra emphasis."
        case .pill:
            return "Badges, chips, and overline labels."
        case .button:
            return "Primary and secondary button titles."
        case .metric:
            return "Dashboard counts and prominent numeric values."
        }
    }
}

extension UIFont {
    static func themedFont(_ style: PoochyFontStyle) -> UIFont {
        let font = UIFont.systemFont(ofSize: style.pointSize, weight: style.weight)
        return UIFontMetrics(forTextStyle: style.textStyle).scaledFont(for: font)
    }
}
