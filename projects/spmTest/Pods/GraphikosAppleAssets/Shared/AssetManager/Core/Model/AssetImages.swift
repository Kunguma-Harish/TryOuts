//
//  AssetImages.swift
//  GraphikosAppleAssets
//
//  Created by Sarath Kumar G on 21/07/22.
//  Copyright © 2022 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation

public class AssetImages: NSObject, AssetNameSpace {
    public static func getImage(
        for imageType: AssetImageTypeRepresentable,
        with themeType: AppThemeColorType = .red,
        suffix: String = "",
        symbolConfigurations: [PlatformSymbolConfiguration] = []
    ) -> PlatformImage {
        imageType.getImage(
            for: themeType,
            suffix: suffix,
            symbolConfigurations: symbolConfigurations
        )
    }

    public static func getImage(for key: String) -> PlatformImage {
        PlatformImage.getImage(named: key)
    }

    deinit {
        Debugger.deInit(self.classForCoder)
    }
}
