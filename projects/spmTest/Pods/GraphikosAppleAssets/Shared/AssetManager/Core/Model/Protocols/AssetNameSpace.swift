//
//  AssetNameSpace.swift
//  GraphikosAppleAssets
//
//  Created by Sarath Kumar G on 28/08/22.
//  Copyright © 2022 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

public protocol AssetNameSpace {
    #if os(macOS)
        typealias PlatformColor = NSColor
        typealias PlatformImage = NSImage
        typealias PlatformSymbolConfiguration = NSImage.SymbolConfiguration
    #else
        typealias PlatformColor = UIColor
        typealias PlatformImage = UIImage
        typealias PlatformSymbolConfiguration = UIImage.SymbolConfiguration
    #endif
}

public extension AssetNameSpace.PlatformColor {
    convenience init(
        redWhole: CGFloat,
        greenWhole: CGFloat,
        blueWhole: CGFloat,
        alpha: CGFloat = 1.0
    ) {
        self.init(
            red: redWhole / 255.0,
            green: greenWhole / 255.0,
            blue: blueWhole / 255.0,
            alpha: alpha
        )
    }

    convenience init(rgb: CGFloat, alpha: CGFloat = 1.0) {
        self.init(
            red: rgb / 255.0,
            green: rgb / 255.0,
            blue: rgb / 255.0,
            alpha: alpha
        )
    }
}

extension AssetNameSpace.PlatformColor {
    static func getColor(named colorName: String) -> AssetNameSpace.PlatformColor? {
        // NOTE: If pod is integrated as static library, try initializing color from 'main' bundle
        var color = AssetNameSpace.PlatformColor(named: colorName)
        if color == nil {
            // NOTE: If pod is integrated as framework, try initializing color from 'assets' bundle
            let assetsBundle = Bundle.graphikosAppleAssets
            #if os(macOS)
                color = AssetNameSpace.PlatformColor(
                    named: colorName,
                    bundle: assetsBundle
                )
            #else
                color = AssetNameSpace.PlatformColor(
                    named: colorName,
                    in: assetsBundle,
                    compatibleWith: nil
                )
            #endif
        }
        return color
    }
}

extension AssetNameSpace.PlatformImage {
    static func getImage(named imageName: String) -> AssetNameSpace.PlatformImage {
        // NOTE: If pod is integrated as static library, try initializing image from 'main' bundle
        var image = AssetNameSpace.PlatformImage(named: imageName)
        if image == nil {
            // NOTE: If pod is integrated as framework, try initializing image from 'assets' bundle
            let assetsBundle = Bundle.graphikosAppleAssets
            #if os(macOS)
                image = assetsBundle.image(forResource: imageName)
            #else
                image = AssetNameSpace.PlatformImage(
                    named: imageName,
                    in: assetsBundle,
                    compatibleWith: nil
                )
            #endif
        }
        return image ?? AssetNameSpace.PlatformImage()
    }

    static func getSFSymbol(
        named imageName: String,
        symbolConfigurations: [AssetNameSpace.PlatformSymbolConfiguration] = []
    ) -> AssetNameSpace.PlatformImage {
        var image: AssetNameSpace.PlatformImage?
        #if os(macOS)
            image = AssetNameSpace.PlatformImage(
                systemSymbolName: imageName,
                accessibilityDescription: ""
            )
            if image == nil {
                image = self.getImage(named: imageName)
            }
            for configuration in symbolConfigurations {
                if let newImage = image?.withSymbolConfiguration(configuration) {
                    image = newImage
                }
            }
        #else
            image = AssetNameSpace.PlatformImage(systemName: imageName)
            if image == nil {
                image = self.getImage(named: imageName)
            }
            for configuration in symbolConfigurations {
                if let newImage = image?.applyingSymbolConfiguration(configuration) {
                    image = newImage
                }
            }
        #endif
        return image ?? AssetNameSpace.PlatformImage()
    }
}
