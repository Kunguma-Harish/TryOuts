//
//  ColorCompatibility.swift
//  GraphikosAppleAssets
//
//  Created by Sarath Kumar G on 03/11/22.
//  Copyright © 2022 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation

// Referred from https://noahgilmore.com/blog/dark-mode-uicolor-compatibility/
enum ColorCompatibility {
    static var separator: AssetNameSpace.PlatformColor {
        #if os(macOS)
            return .separatorColor
        #else
            return .separator
        #endif
    }

    static var opaqueSeparator: AssetNameSpace.PlatformColor {
        #if os(macOS)
            // NOTE: opaqueSeparator equivalent is not available in macOS
            return .separatorColor
        #else
            return .opaqueSeparator
        #endif
    }

    #if !os(tvOS)
        static var systemBackground: AssetNameSpace.PlatformColor {
            #if os(macOS)
                return .windowBackgroundColor
            #else
                return .systemBackground
            #endif
        }
    #endif
}
