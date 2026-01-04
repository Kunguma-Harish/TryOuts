//
//  AssetColorTypes_macOS.swift
//  Show-macOS
//
//  Created by harish-13272 on 19/08/22.
//  Copyright © 2022 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import AppKit

public enum BackgroundColorType: AssetColorTypeRepresentable {
    case buttonDisabledColor
    case bulletBorderColor
    case bBoxFillForDragToMultiselect
    case secondaryBackgroundColor
    case insertBackgroundColor
}

public enum BasicColorType: AssetColorTypeRepresentable {
    case gray
    case shadowColor
    case systemRedColor
    case controlAccentColor
    case secondaryLabelColor
    case insertShadowColor
    case opaqueSeparatorColor

    public func getColor(for _: AssetColorState, themeType _: AppThemeColorType) -> NSColor {
        switch self {
        case .gray:
            return NSColor.gray
        case .controlAccentColor:
            return NSColor.controlAccentColor
        case .opaqueSeparatorColor:
            return ColorCompatibility.opaqueSeparator
        case .systemRedColor:
            return NSColor.systemRed
        case .secondaryLabelColor:
            return NSColor.secondaryLabelColor
        default:
            return self.getColor() ?? .black
        }
    }
}

public enum TextColorType: AssetColorTypeRepresentable {
    case textLinkColor
    case bulletTextColor
}

public enum BorderColors: AssetColorTypeRepresentable {
    case insertImagePHTint
    case listingCellBorder
    case popOverCellBorderColor
}
