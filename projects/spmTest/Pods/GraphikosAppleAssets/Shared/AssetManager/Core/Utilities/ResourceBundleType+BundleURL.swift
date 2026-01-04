//
//  ResourceBundleType+BundleURL.swift
//  GraphikosAppleAssets
//
//  Created by Sarath Kumar G on 15/11/23.
//  Copyright © 2023 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation

public extension ResourceBundleType {
    var resourceURL: URL? {
        var bundle: Bundle?
        #if os(iOS) || os(tvOS)
            bundle = .main
        #elseif os(macOS)
            bundle = Bundle.getBundle(for: .renderingResources)
        #else
            assertionFailure("Invalid deployment platform in \(#function)")
        #endif
        return bundle?.url(forResource: rawValue, withExtension: "bundle")
    }
}
