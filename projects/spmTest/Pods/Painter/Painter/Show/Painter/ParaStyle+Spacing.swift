//
//  ParaStyle+Spacing.swift
//  Painter
//
//  Created by Sarath Kumar G on 26/02/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation
import Proto
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit.NSAttributedString
#elseif os(OSX)
import AppKit.NSAttributedString
#endif

extension ParaStyle {
	/// Sets line height according to different fonts contained in a 'Paragraph'
	func setSpacing(
		ofValue spacing: CGFloat,
		for attributedString: NSMutableAttributedString,
		with currentParagraphStyle: NSMutableParagraphStyle,
		isExactly exactly: Bool,
		range: NSRange?) {
		let fullRange = range ?? attributedString.fullRange
		let maxLineHeight = attributedString.maxFontSize * 1.2 * spacing

		attributedString.beginEditing()
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.setParagraphStyle(currentParagraphStyle)

		if exactly {
			paragraphStyle.minimumLineHeight = spacing
			paragraphStyle.maximumLineHeight = spacing
		} else {
			paragraphStyle.lineHeightMultiple = spacing
			paragraphStyle.maximumLineHeight = maxLineHeight
		}
		attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: fullRange)
		attributedString.endEditing()
	}
}
