//
//  AssetColors.swift
//  GraphikosAppleAssets
//
//  Created by Sarath Kumar G on 21/07/22.
//  Copyright © 2022 Zoho Corporation Pvt. Ltd. All rights reserved.
//

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

public enum AssetColorState {
    case normal
    case enabled
    case disabled
    case focused
}

public class AssetColors: NSObject, AssetNameSpace {
    #if os(macOS)
        public static func getColor(
            for colorType: AssetColorTypeRepresentable,
            with colorState: AssetColorState = .normal,
            themeType: AppThemeColorType = .red,
            withAlpha alpha: CGFloat? = nil
        ) -> PlatformColor {
            let color = colorType.getColor(for: colorState, themeType: themeType)
            guard let alpha else {
                return color
            }
            return color.withAlphaComponent(alpha)
        }
    #else
        public static func getColor(
            for colorType: AssetColorTypeRepresentable,
            with colorState: AssetColorState = .normal,
            themeType: AppThemeColorType = .red,
            traitCollection: UITraitCollection? = nil,
            withAlpha alpha: CGFloat? = nil
        ) -> PlatformColor {
            var color = colorType.getColor(for: colorState, themeType: themeType)
            if let traitCollection {
                color = color.resolvedColor(with: traitCollection)
            }
            guard let alpha else {
                return color
            }
            return color.withAlphaComponent(alpha)
        }
    #endif

    deinit {
        Debugger.deInit(self.classForCoder)
    }
}
