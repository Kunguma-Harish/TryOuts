//
//  AssetColorTypes_iOS.swift
//  Show-iOS
//
//  Created by Sarath Kumar G on 20/07/22.
//  Copyright © 2022 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import UIKit

public enum BackgroundColorType: AssetColorTypeRepresentable {
    case actionSheetSelectedBGColor
    case backgroundPrimaryColor
    case backgroundSecondaryColor
    case backgroundTertiaryColor
    case buttonBGPrimaryColor
    case editorBGColor
    case insertAddonsBGColor
    case formatBackgroundColor
    case listingPrimaryBGColor
    case listingSecondaryBGColor
    case primaryShimmerColor
    case secondaryShimmerColor
    case primaryCollectionViewCellBG
    case toastBackgroundColor
    case tutorialBoardBGColor
    case bBoxFillForDragToMultiselect
    case textFieldBackgroundColor
}

public enum ListingColorType: AssetColorTypeRepresentable {
    case listingCellBorder
}

public enum BasicColorType: AssetColorTypeRepresentable {
    case blackColor
    case blueColor
    case border
    case clearColor
    case darkGrayColor
    case grayColor
    case greenColor
    case hyperlinkColor
    case lightGrayColor
    case opaqueSeparatorColor
    case orangeColor
    case purpleColor
    case red
    case sectionTitle
    case shadowColor
    case systemBackgroundColor
    case title
    case whiteColor
    case insertShadowColor

    public func getColor(
        for state: AssetColorState,
        themeType _: AppThemeColorType
    ) -> UIColor {
        switch self {
        case .blackColor:
            return .black
        case .blueColor:
            return .blue
        case .border:
            return ColorCompatibility.separator
        case .clearColor:
            return .clear
        case .darkGrayColor:
            return .darkGray
        case .grayColor:
            return .gray
        case .hyperlinkColor:
            return self.getColor(named: "textLinkColor") ?? .blue
        case .lightGrayColor:
            return .lightGray
        case .opaqueSeparatorColor:
            return ColorCompatibility.opaqueSeparator
        case .red:
            return self.getColor(named: "redPrimaryColor") ?? .red
        case .sectionTitle:
            return self.getColor(named: "textSecondaryColor") ?? .gray
        case .systemBackgroundColor:
            return ColorCompatibility.systemBackground
        case .title:
            if state == .disabled {
                return self.getColor(named: "textTertiaryColor") ?? .lightGray
            }
            return self.getColor(named: "textPrimaryColor") ?? .black
        case .whiteColor:
            return .white
        default:
            return self.getColor() ?? .black
        }
    }
}

public enum ThemeColorType: AssetColorTypeRepresentable {
    case accent
    case notificationUnRead
    case primary
    case strokeSelected
    case toastBG
    case onPress

    public func getColor(for _: AssetColorState, themeType: AppThemeColorType) -> UIColor {
        let prefix = String(describing: themeType)
        switch self {
        case .accent:
            return self.getColor(named: "\(prefix)AccentColor") ?? .gray
        case .notificationUnRead:
            return self.getColor(named: "\(prefix)NotificationUnReadColor") ?? .lightGray
        case .primary:
            return self.getColor(named: "\(prefix)PrimaryColor") ?? .black
        case .strokeSelected:
            return self.getColor(named: "\(prefix)StrokeSelectedColor") ?? ColorCompatibility.separator
        case .toastBG:
            return self.getColor(named: "\(prefix)ThemeToastBGColor") ?? .lightGray
        case .onPress:
            return self.getColor(named: "\(prefix)OnPressColor") ?? .black
        }
    }
}

public enum TextColorType: AssetColorTypeRepresentable {
    case noNetworkTextSecondaryColor
    case textLinkColor
    case textPrimaryColor
    case textSecondaryColor
    case textTertiaryColor
}

public enum TintColorType: AssetColorTypeRepresentable {
    case insertPresetShapeTintColor
    case navBarPrimaryTintColor
}
