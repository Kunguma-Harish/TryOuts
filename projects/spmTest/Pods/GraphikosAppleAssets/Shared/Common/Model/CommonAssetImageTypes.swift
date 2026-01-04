//
//  CommonAssetImageTypes.swift
//  GraphikosAppleAssets
//
//  Created by shyam-8423 on 09/01/24.
//  Copyright © 2024 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation

public enum PlaybackAudioImageType: AssetImageTypeRepresentable {
    case playFill
    case pauseFill
    case playCircle
    case pauseCircle
    case trash

    var systemSymbolName: String? {
        switch self {
        case .playFill:
            return "play.fill"
        case .pauseFill:
            return "pause.fill"
        case .playCircle:
            return "play.circle"
        case .pauseCircle:
            return "pause.circle"
        case .trash:
            return "trash.fill"
        }
    }

    public func getImage(
        for _: AppThemeColorType,
        suffix _: String,
        symbolConfigurations: [PlatformSymbolConfiguration]
    ) -> PlatformImage {
        if let systemSymbolName {
            return getSFSymbol(
                named: systemSymbolName,
                symbolConfigurations: symbolConfigurations
            )
        }
        return self.getImage()
    }
}
