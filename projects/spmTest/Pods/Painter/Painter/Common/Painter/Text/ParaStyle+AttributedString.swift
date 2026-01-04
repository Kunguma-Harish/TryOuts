//
//  ParaStyle+AttributedString.swift
//  Painter
//
//  Created by Sarath Kumar G on 16/08/17.
//  Copyright © 2017 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit.NSAttributedString
#else
import AppKit.NSAttributedString
#endif
import Proto

extension ParaStyle {
	var alignment: NSTextAlignment {
		return halign.alignment
	}

	/// Add attributes corresponding to 'ListStyle' for a 'Paragraph'
	func setListStyle(
		for attrbString: NSMutableAttributedString,
		atIndex paraIndex: Int,
		with fontProps: FontProps,
		and scaleProps: ScaleProps,
		bulletFree: Bool,
		using config: PainterConfig? = nil) -> NSMutableParagraphStyle {
		let fontScale = scaleProps.fontScale
		let paragraphStyle = NSMutableParagraphStyle()
		if hasMargin {
			let marginLeft = CGFloat(margin.left * fontScale)
			paragraphStyle.headIndent = marginLeft
		}

		let bulletAttributedString = self.getBulletAttributedString(
			forIndex: paraIndex,
			with: fontProps,
			and: scaleProps,
			using: config)
		var bulletIndent = self.computeBulletIndent(bulletAttributedString: bulletAttributedString, scaleProps: scaleProps)

		if bulletAttributedString.string.isEmpty {
			paragraphStyle.firstLineHeadIndent = bulletIndent
		} else {
			// Kerning
			let width = bulletAttributedString.size().width
			let kernValue = getBulletSplitter(ofWidth: Float(width), andScale: fontScale)

			if bulletFree {
				bulletIndent += width + CGFloat(kernValue)
			}
			paragraphStyle.firstLineHeadIndent = bulletIndent

			if !bulletFree {
				let kernRange = NSRange(location: bulletAttributedString.length - 1, length: 1)
				bulletAttributedString.addAttribute(.kern, value: kernValue, range: kernRange)

				let range = bulletAttributedString.fullRange
				bulletAttributedString.addAttribute(.zsIsBullet, value: true, range: range)
				attrbString.append(bulletAttributedString)
			}
		}
		return paragraphStyle
	}

	func computeBulletIndent(
		bulletAttributedString: NSMutableAttributedString,
		scaleProps: ScaleProps) -> CGFloat {
		var (firstLineHeadIndent, headIndent): (CGFloat, CGFloat) = (0, 0)
		let fontScale = scaleProps.fontScale
		if hasMargin {
			let marginLeft = CGFloat(margin.left * fontScale)
			headIndent = marginLeft
			firstLineHeadIndent = marginLeft
		}

		if hasIndent {
			firstLineHeadIndent += CGFloat(indent * fontScale)
		}

		guard !bulletAttributedString.string.isEmpty else {
			return firstLineHeadIndent
		}

		return (firstLineHeadIndent >= headIndent) ? headIndent : firstLineHeadIndent
	}

	/// Add attributes corresponding to 'ParagraphStyle' for a 'Paragraph'
	func setParaStyle(
		to attributedString: NSMutableAttributedString,
		with paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle(),
		and scaleProps: ScaleProps,
		canUseParaSpacing: (before: Bool, after: Bool),
		range: NSRange? = nil) {
		if hasHalign { // Horizontal Alignment
			paragraphStyle.alignment = self.alignment
		}
		if canUseParaSpacing.before, hasSpacing, spacing.hasBefore { // Paragraph Spacing Before
			let bSpacing = self.getParaSpacing(from: spacing.before, with: scaleProps)
			paragraphStyle.paragraphSpacingBefore = bSpacing
		}
		if canUseParaSpacing.after, hasSpacing, spacing.hasAfter { // Paragraph Spacing After
			let aSpacing = self.getParaSpacing(from: spacing.after, with: scaleProps)
			paragraphStyle.paragraphSpacing = aSpacing
		}

		attributedString.addAttribute(
			.paragraphStyle,
			value: paragraphStyle,
			range: range ?? attributedString.fullRange)
		if self.hasStyleRef {
			attributedString.addAttribute(.zsCharacterParaStyleRef, value: self.styleRef, range: range ?? attributedString.fullRange)
		}

		if hasSpacing, spacing.hasLine { // Paragraph Line Spacing
			setSpacing(
				ofValue: CGFloat(self.getParaSpacing(from: spacing.line, with: scaleProps)),
				for: attributedString,
				with: paragraphStyle,
				isExactly: (spacing.line.type == .absolute) ? true : false,
				range: range)
		}
		if hasListStyle, listStyle.hasBullet {
			let range = attributedString.fullRange
			attributedString.addAttribute(.zsListParaStyle, value: self, range: range)
		}
	}

	func getBulletAttributedString(
		forIndex paraIndex: Int,
		with fontProps: FontProps,
		and scaleProps: ScaleProps,
		using config: PainterConfig? = nil) -> NSMutableAttributedString {
		var unicodeCharacter = ""
		var fontSize = fontProps.size
		let fontScale = scaleProps.fontScale

		// Below code only to be executed when
		if hasListStyle {
			if listStyle.hasBullet, paraIndex != Int.max {
				unicodeCharacter = listStyle.bullet.getBulletCharacter(
					forIndex: paraIndex
				)
			}
			if listStyle.hasSize, listStyle.size > 0 {
				fontSize *= listStyle.size * fontScale // 'size' is a decimal that holds ratio of bullet size over font size
			} else {
				fontSize *= fontScale
			}
		}

		if unicodeCharacter.isEmpty {
			return NSMutableAttributedString()
		}

		let bulletAttributedString = NSMutableAttributedString(string: unicodeCharacter)
		let bulletRange = NSRange(location: 0, length: bulletAttributedString.length)
		let bulletColor = (hasListStyle && listStyle.hasColor) ? listStyle.color.platformColor : fontProps.color

		if bulletAttributedString.length == 0 {
			bulletAttributedString.mutableString.append(" ") // Add space if liststyle is empty
		}
		bulletAttributedString.addAttribute(.foregroundColor, value: bulletColor, range: bulletRange)

		// Font
		addFont(to: bulletAttributedString, ofSize: CGFloat(fontSize * fontScale), using: config)
		return bulletAttributedString
	}

	func getParaSpacing(
		from spacingValue: ParaStyle.Spacing.SpacingValue,
		with scaleProps: ScaleProps) -> CGFloat {
		var customSpacing: Float = 1.0
		switch spacingValue.type {
		case .percent:
			customSpacing = spacingValue.percent
		case .absolute:
			customSpacing = spacingValue.absolute // * scaleProps.fontScale
		}

//		if scaleProps.lineSpaceScale > 0 {
//			customSpacing *= scaleProps.lineSpaceScale
//		}
		return CGFloat(customSpacing)
	}
}

// MARK: - ParaStyle Helpers

public extension ParaStyle {
//	var fontId: String? {
//		if let familyName = listStyle.font.fontFamily.name.cString(using: String.Encoding.utf8) {
//			let fontFamily = String(cString: familyName)
//			let styleId = "400" // set default font-weight to ".normal"
//			return getFontID(forFamily: fontFamily, withStyle: styleId)
//		}
//		return nil
//	}

	var hasBullet: Bool {
		guard
			self.hasListStyle,
			self.listStyle.hasBullet,
			self.listStyle.bullet.hasType,
			self.listStyle.bullet.type != .none
		else {
			return false
		}
		return true
	}

	func addFont(
		to attributedString: NSMutableAttributedString,
		ofSize fontSize: CGFloat,
		using config: PainterConfig?) {
		let range = NSRange(location: 0, length: attributedString.length)
		let fontId = listStyle.font.getFontId(forStyle: "400", using: config)
#if os(iOS) || os(tvOS) || os(watchOS)
		let bulletFont = UIFont(name: fontId, size: fontSize) // UIFont
		attributedString.addAttribute(.font, value: bulletFont as Any, range: range)
#else
		let bulletFont = NSFont(name: fontId, size: fontSize) // NSFont
		attributedString.addAttribute(.font, value: bulletFont as Any, range: range)
#endif
	}

	/// Fetch bullet splitter
	func getBulletSplitter(ofWidth bulletWidth: Float, andScale scale: Float) -> Float {
		let paraStyleIndent = indent * scale
		let positiveIndent = paraStyleIndent * -1
		var bulletSplitter: Float = 0.0
		var marginLeft: Float = (hasMargin && margin.hasLeft) ? margin.left : 0.0
		marginLeft *= scale

		if paraStyleIndent < 0 {
			bulletSplitter = positiveIndent - bulletWidth
			bulletSplitter = (bulletWidth > 0) ? bulletSplitter : 0
		} else {
			bulletSplitter = (paraStyleIndent > bulletWidth) ? (paraStyleIndent - bulletWidth) : 0
		}

		if bulletSplitter < 0 {
			return bulletSplitter * -1
		}
		return bulletSplitter
	}
}

// MARK: - Bullet Data Helpers

public extension ParaStyle.ListStyle.BulletData {
	/// Get bullet character at given Paragraph index
	/// - Parameter paraIndex: Paragraph index
	func getBulletCharacter(forIndex paraIndex: Int) -> String {
		var bulletChar = ""
		if !hasType {
			return bulletChar
		}

		switch type {
		case .character:
			if let characterString = character.ch.cString(using: .utf8) {
				let unicodeValue = String(cString: characterString)
				if let unicodeChar = unicodeValue.charBulletUnicode {
					bulletChar = unicodeChar
				} else if var unicode = unichar(unicodeValue) {
					bulletChar = String(utf16CodeUnits: &unicode, count: 1)
				}
			}
		case .number:
			bulletChar = number.getUnicodeCharacter(forIndex: paraIndex)
		default:
			break
		}
		return bulletChar
	}
}

// MARK: - Numbered Bullet Helpers

private extension ParaStyle.ListStyle.BulletData.NumberedBullet {
	/// Numbered bullet string for given Paragraph index
	/// - Parameter paraIndex: Paragraph index
	func getUnicodeCharacter(forIndex paraIndex: Int) -> String {
		var unicodeCharacter = ""
		var bulletSuffix = ""

		if hasSuffix {
			if let suffix = suffix.cString(using: .utf8) {
				bulletSuffix = String(cString: suffix)
			}
		}
		if !hasType {
			return "\(String(paraIndex))\(bulletSuffix)"
		}

		switch type {
		case .ucalphabet, .lcalphabet:
			unicodeCharacter = self.getAlphaString(forIndex: paraIndex)
		case .ucroman, .lcroman:
			unicodeCharacter = self.getRomanString(forIndex: paraIndex)
		case .numeric:
			unicodeCharacter = self.getNumericString(forIndex: paraIndex)
		}
		return "\(unicodeCharacter)\(bulletSuffix)"
	}

	/// Alphabetic bullet string for given paragraph index
	/// - Parameter paraIndex: Paragraph index
	func getAlphaString(forIndex paraIndex: Int) -> String {
		let startValue = Int(((type == .ucalphabet ? "A" : "a") as UnicodeScalar).value)
		let revisedIndex = paraIndex - 1
		return String(repeating: String(Character(UnicodeScalar(UInt8(CGFloat(startValue + (revisedIndex % 26)))))), count: (revisedIndex / 26) + 1)
	}

	/// Roman numeral bullet string for given paragraph index
	/// - Parameter paraIndex: Paragraph index
	func getRomanString(forIndex paraIndex: Int) -> String {
		let decimalValue = [1_000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
		let romanNumeral = (type == .ucroman) ?
			["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"] :
			["m", "cm", "d", "cd", "c", "xc", "l", "xl", "x", "ix", "v", "iv", "i"]
		var romanEquivalent = ""
		var num = paraIndex

		for index in 0..<decimalValue.count {
			// Continue to loop while the value at the current index will fit into numCopy
			while decimalValue[index] <= num {
				romanEquivalent += romanNumeral[index]
				num -= decimalValue[index]
			}
		}
		return romanEquivalent
	}

	/// Numeric bullet string for given paragraph index
	/// - Parameter paraIndex: Paragraph index
	func getNumericString(forIndex paraIndex: Int) -> String {
		return String(describing: paraIndex)
	}
}
