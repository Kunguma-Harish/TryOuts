//
//  CTFont+Extras.swift
//  Painter
//
//  Created by Sarath Kumar G on 27/03/20.
//  Copyright © 2020 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation
import Proto
#if os(iOS) || os(tvOS)
import UIKit.NSTextStorage
#elseif os(watchOS)
import UIKit.NSAttributedString
#else
import AppKit.NSTextStorage
#endif

extension CTFont {
	struct PortionPropsAttributes {
		let family: String
		let weight: PortionField.FontWeight
		let width: Float
		let italic: Bool
	}

	func getFontDetails() -> PortionPropsAttributes {
		let family = CTFontCopyFamilyName(self) as String

		let fontTraits = CTFontCopyTraits(self) as NSDictionary
		let weightValue = (fontTraits[kCTFontWeightTrait] as? NSNumber)?.floatValue ?? 0.0
		let widthValue = (fontTraits[kCTFontWidthTrait] as? NSNumber)?.floatValue ?? 0.0
		let slantValue = (fontTraits[kCTFontSlantTrait] as? NSNumber)?.floatValue ?? 0.0

		let protoWeight = PortionField.FontWeight.getWeight(forSystemValue: weightValue)
		let italic = slantValue != 0.0

		return PortionPropsAttributes(family: family, weight: protoWeight, width: widthValue, italic: italic)
	}
}
