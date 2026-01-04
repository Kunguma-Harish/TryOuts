//
//  DeviceColor+Helpers.swift
//  Painter
//
//  Created by charan-14779 on 04/01/24.
//  Copyright © 2024 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension DeviceColor {
	func blend(with color: DeviceColor, alpha: CGFloat) -> DeviceColor {
		let alphaSelf = 1.0 - alpha
		let alphaOther = alpha

		var redSelf: CGFloat = 0.0
		var greenSelf: CGFloat = 0.0
		var blueSelf: CGFloat = 0.0
		var alphaSelfComponent: CGFloat = 0.0

		var redOther: CGFloat = 0.0
		var greenOther: CGFloat = 0.0
		var blueOther: CGFloat = 0.0
		var alphaOtherComponent: CGFloat = 0.0

		getRed(&redSelf, green: &greenSelf, blue: &blueSelf, alpha: &alphaSelfComponent)
		color.getRed(&redOther, green: &greenOther, blue: &blueOther, alpha: &alphaOtherComponent)

		let blendedRed = redSelf * alphaSelf + redOther * alphaOther
		let blendedGreen = greenSelf * alphaSelf + greenOther * alphaOther
		let blendedBlue = blueSelf * alphaSelf + blueOther * alphaOther
		let blendedAlpha = alphaSelfComponent * alphaSelf + alphaOtherComponent * alphaOther

		return DeviceColor(red: blendedRed, green: blendedGreen, blue: blendedBlue, alpha: blendedAlpha)
	}
}
