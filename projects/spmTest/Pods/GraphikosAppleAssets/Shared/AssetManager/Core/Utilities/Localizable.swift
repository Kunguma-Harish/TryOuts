//
//  Localizable.swift
//  GraphikosAppleAssets
//
//  Created by Sarath Kumar G on 21/11/22.
//  Copyright © 2022 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation

public protocol Localizable {
    var localized: String { get }
}

public extension Localizable where Self: RawRepresentable, Self.RawValue == String {
    var localized: String {
        NSLocalizedString(rawValue, bundle: .main, comment: "")
    }
}
