//
//  ShowFontManager+RegisterFont.swift
//  GraphikosAppleAssets
//
//  Created by Sarath Kumar G on 14/11/23.
//  Copyright © 2023 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation

extension ShowFontManager {
    func registerFontFromLocalStorage(
        fontName: String?,
        success: @escaping (String?) -> Void,
        failure: @escaping (Error) -> Void
    ) {
        if let fontsBundleUrl {
            self.registerFont(
                fontName: fontName,
                bundleUrl: fontsBundleUrl,
                success: success,
                failure: failure
            )
        } else {
            self.downloadOnDemandResources(
                fontName: fontName,
                success: success,
                failure: failure
            )
        }
    }
}

private extension ShowFontManager {
    func downloadOnDemandResources(
        fontName: String?,
        success: @escaping (String?) -> Void,
        failure: @escaping (Error) -> Void
    ) {
        #if os(iOS) || os(tvOS)
            Task {
                do {
                    try await OnDemandResourceManager.shared.fetchResources(
                        ofTypes: [.fonts]
                    )
                    if let fontsBundleUrl = self.fontsBundleUrl {
                        self.registerFont(
                            fontName: fontName,
                            bundleUrl: fontsBundleUrl,
                            success: success,
                            failure: failure
                        )
                    } else {
                        failure(FontHandlingError.fontsBundlePathUnavailable)
                    }
                } catch {
                    failure(error)
                }
            }
        #else
            failure(FontHandlingError.fontsBundlePathUnavailable)
        #endif
    }
}
