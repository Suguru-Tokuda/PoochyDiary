//
//  PoochyTypography.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/10/26.
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
            return Strings.Typography.heroTitle
        case .screenTitle:
            return Strings.Typography.screenTitle
        case .sectionTitle:
            return Strings.Typography.sectionTitle
        case .cardTitle:
            return Strings.Typography.cardTitle
        case .body:
            return Strings.Typography.body
        case .bodyEmphasized:
            return Strings.Typography.bodyEmphasized
        case .caption:
            return Strings.Typography.caption
        case .captionEmphasized:
            return Strings.Typography.captionEmphasized
        case .pill:
            return Strings.Typography.pill
        case .button:
            return Strings.Typography.button
        case .metric:
            return Strings.Typography.metric
        }
    }

    var usage: String {
        switch self {
        case .heroTitle:
            return Strings.Typography.heroTitleUsage
        case .screenTitle:
            return Strings.Typography.screenTitleUsage
        case .sectionTitle:
            return Strings.Typography.sectionTitleUsage
        case .cardTitle:
            return Strings.Typography.cardTitleUsage
        case .body:
            return Strings.Typography.bodyUsage
        case .bodyEmphasized:
            return Strings.Typography.bodyEmphasizedUsage
        case .caption:
            return Strings.Typography.captionUsage
        case .captionEmphasized:
            return Strings.Typography.captionEmphasizedUsage
        case .pill:
            return Strings.Typography.pillUsage
        case .button:
            return Strings.Typography.buttonUsage
        case .metric:
            return Strings.Typography.metricUsage
        }
    }
}

extension UIFont {
    static func themedFont(_ style: PoochyFontStyle) -> UIFont {
        let font = UIFont.systemFont(ofSize: style.pointSize, weight: style.weight)
        return UIFontMetrics(forTextStyle: style.textStyle).scaledFont(for: font)
    }
}
