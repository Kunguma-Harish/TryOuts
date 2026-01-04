//
//  String+Regex.swift
//  GraphikosAppleAssets
//
//  Created by Sarath Kumar G on 09/09/22.
//  Copyright © 2022 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation

extension String {
    func matches(_ regex: String) -> Bool {
        range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
