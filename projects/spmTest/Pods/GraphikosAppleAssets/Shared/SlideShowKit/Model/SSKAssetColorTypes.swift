//
//  SSKAssetColorTypes.swift
//  GraphikosAppleAssets
//
//  Created by Sarath Kumar G on 20/07/22.
//  Copyright © 2022 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation

public enum SSKBasicColorType: AssetColorTypeRepresentable {
    case blackColor
    case border
    case clearColor
    case red
    case whiteColor

    public func getColor(
        for _: AssetColorState,
        themeType _: AppThemeColorType
    ) -> PlatformColor {
        switch self {
        case .blackColor:
            return .black
        case .border:
            #if os(macOS)
                return .separatorColor
            #else
                return ColorCompatibility.separator
            #endif
        case .clearColor:
            return .clear
        case .red:
            return self.getColor(named: "redPrimaryColor") ?? .red
        case .whiteColor:
            return .white
        }
    }
}
