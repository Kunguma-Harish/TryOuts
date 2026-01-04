//
//  String+Extras.swift
//  Painter
//
//  Created by Sarath Kumar G on 13/04/20.
//  Copyright © 2020 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation

public extension String {
	var charBulletUnicode: String? {
		var character: String?
		if let unicode = Int(self) {
			switch unicode {
			case 111:
				character = "\u{25CB}"
			case 113:
				character = "\u{2751}"
			case 118:
				character = "\u{2756}"
			case 167:
				character = "\u{25A0}"
			case 216:
				character = "\u{27A2}"
			case 252:
				character = "\u{2713}"
			case 8_226:
				character = "\u{2022}"
			default:
				break
			}
		}
		return character
	}

	var isCharacterBullet: Bool {
		switch self {
		case "\u{25CB}", "\u{2751}", "\u{2756}", "\u{25AA}", "\u{27A2}", "\u{2713}", "\u{2022}":
			return true
		default:
			return false
		}
	}

	func matches(_ regex: String) -> Bool {
		return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
	}
}
