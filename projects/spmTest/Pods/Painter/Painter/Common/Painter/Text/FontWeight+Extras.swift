//
//  FontWeight+Extras.swift
//  Painter
//
//  Created by Sarath Kumar G on 27/03/20.
//  Copyright © 2020 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation
import Proto

extension PortionField.FontWeight {
	static func getWeight(forSystemValue systemValue: Float) -> PortionField.FontWeight {
		assert(systemValue >= -1 && systemValue <= 1)
		if systemValue <= -0.80 {
			return .thin
		} else if systemValue <= -0.60 {
			return .extraLight
		} else if systemValue <= -0.40 {
			return .light
		} else if systemValue <= 0.0 {
			return .normal
		} else if systemValue <= 0.23 {
			return .medium
		} else if systemValue <= 0.30 {
			return .demiBold
		} else if systemValue <= 0.40 {
			return .bold
		} else if systemValue <= 0.56 {
			return .heavy
		} else if systemValue <= 0.62 {
			return .black
		} else {
			assertionFailure()
			return .black
		}
	}
}
