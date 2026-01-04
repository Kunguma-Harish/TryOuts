//
//  AssetColorTypeRepresentable.swift
//  GraphikosAppleAssets
//
//  Created by Sarath Kumar G on 20/07/22.
//  Copyright © 2022 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation

public protocol AssetColorTypeRepresentable: AssetNameSpace {
    func getColor(for state: AssetColorState, themeType: AppThemeColorType) -> PlatformColor
}

public extension AssetColorTypeRepresentable {
    func getColor(for _: AssetColorState, themeType _: AppThemeColorType) -> PlatformColor {
        self.getColor() ?? .black
    }
}

extension AssetColorTypeRepresentable {
    func getColor(named assetColorName: String? = nil) -> PlatformColor? {
        let colorName = assetColorName ?? String(describing: self)
        return PlatformColor.getColor(named: colorName)
    }
}
