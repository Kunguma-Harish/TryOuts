//
//  SSKLocalizable.swift
//  GraphikosAppleAssets
//
//  Created by Sarath Kumar G on 21/11/22.
//  Copyright © 2022 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation

public protocol SSKLocalizable: Localizable {}

public extension SSKLocalizable where Self: RawRepresentable, Self.RawValue == String {
    var localized: String {
        NSLocalizedString(
            rawValue,
            tableName: "\(SSKLocalizable.self)",
            bundle: .main,
            comment: ""
        )
    }
}
