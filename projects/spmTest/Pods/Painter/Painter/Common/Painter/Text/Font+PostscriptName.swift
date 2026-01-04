//
//  Font+PostscriptName.swift
//  Painter
//
//  Created by Sarath Kumar G on 14/12/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation
import Proto

extension Font {
	func getFontId(forStyle styleId: String, using config: PainterConfig?) -> String {
		return PainterFontHandler.shared.getFontID(
			forFamily: self.fontFamily.name,
			withStyle: styleId,
			using: config)
	}
}
