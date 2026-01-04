//
//  Bundle+Helpers.swift
//  GraphikosAppleAssets
//
//  Created by Sarath Kumar G on 20/07/22.
//  Copyright © 2022 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation

private final class GAABundleIdentifier: NSObject {
    deinit {
        Debugger.deInit(self.classForCoder)
    }
}

public extension Bundle {
    static var graphikosAppleAssets: Bundle {
        Bundle(for: GAABundleIdentifier.self)
    }

    enum BundleType: String {
        case showAssets = "ShowAssets"
        case showResources = "ShowResources"
        case painterResources = "PainterResources"
        case renderingResources = "RenderingResources"
    }

    static func getBundle(for type: BundleType) -> Bundle {
        // NOTE: If pod is integrated as static library, try loading bundle from 'main' bundle
        var bundlePath = Bundle.main.path(forResource: type.rawValue, ofType: "bundle")
        if bundlePath == nil {
            // NOTE: If pod is integrated as framework, try loading bundle from 'assets' bundle
            bundlePath = Bundle.graphikosAppleAssets.path(
                forResource: type.rawValue,
                ofType: "bundle"
            )
        }
        guard let bundlePath, let bundle = Bundle(path: bundlePath) else {
            assertionFailure("\(type) bundle unavailable in \(#function)")
            return .main
        }
        return bundle
    }
}
