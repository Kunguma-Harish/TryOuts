//
//  SSKAssetImageTypes_iOS.swift
//  SlideShowKit-iOS
//
//  Created by Sarath Kumar G on 03/10/22.
//  Copyright © 2022 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import UIKit

public enum SSKSharePlayImageType: AssetImageTypeRepresentable {
    case iPadSlideShowLandingPageBG
    case iPhoneSlideShowLandingPageBG
    case sharePlaySSKit
    case sharePlayPlaceHolder
}

public enum SSKMCPeerImageTypes: AssetImageTypeRepresentable {
    case appleTVListingBG
    case appleTVListingThemedBG

    public func getImage(
        for themeType: AppThemeColorType,
        suffix _: String,
        symbolConfigurations _: [PlatformSymbolConfiguration]
    ) -> UIImage {
        switch self {
        case .appleTVListingThemedBG:
            return self.getImage(named: "appleTVListingBG_\(themeType)")
        default:
            return self.getImage()
        }
    }
}

public enum SSKSlideShowImageType: AssetImageTypeRepresentable {
    case twitterPause
    case twitterPlay
}
