//
//  NSParagraphStyle+Helper.swift
//  Painter
//
//  Created by Sarath Kumar G on 09/01/20.
//  Copyright © 2020 Zoho Corporation Pvt. Ltd. All rights reserved.
//

#if os(macOS)
import AppKit.NSAttributedString
#elseif os(iOS) || os(tvOS) || os(watchOS)
import UIKit.NSAttributedString
#endif

public extension NSParagraphStyle {
	var absoluteLineHeight: CGFloat {
		return self.maximumLineHeight
	}
}

extension NSParagraphStyle {
	func getModifiedParagraphStyle(fontSize: CGFloat) -> NSParagraphStyle {
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.setParagraphStyle(self)
		let lineHeight = fontSize * 1.2 * paragraphStyle.lineHeightMultiple
		paragraphStyle.maximumLineHeight = lineHeight
		return paragraphStyle
	}
}
