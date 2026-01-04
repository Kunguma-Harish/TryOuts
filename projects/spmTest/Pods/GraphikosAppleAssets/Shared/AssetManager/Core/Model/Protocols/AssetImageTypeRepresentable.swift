//
//  AssetImageTypeRepresentable.swift
//  GraphikosAppleAssets
//
//  Created by Sarath Kumar G on 21/07/22.
//  Copyright © 2022 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation

public protocol AssetImageTypeRepresentable: AssetNameSpace {
    func getImage(
        for themeType: AppThemeColorType,
        suffix: String,
        symbolConfigurations: [PlatformSymbolConfiguration]
    ) -> PlatformImage
}

public extension AssetImageTypeRepresentable {
    func getImage(
        for _: AppThemeColorType,
        suffix _: String,
        symbolConfigurations _: [PlatformSymbolConfiguration]
    ) -> PlatformImage {
        self.getImage()
    }
}

extension AssetImageTypeRepresentable {
    func getImage(named assetImageName: String? = nil) -> PlatformImage {
        let imageName = assetImageName ?? String(describing: self)
        return PlatformImage.getImage(named: imageName)
    }

    func getSFSymbol(
        named systemSymbolName: String,
        symbolConfigurations: [PlatformSymbolConfiguration] = []
    ) -> PlatformImage {
        PlatformImage.getSFSymbol(
            named: systemSymbolName,
            symbolConfigurations: symbolConfigurations
        )
    }
}
