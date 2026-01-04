//
//  NSAttributedString+Extras.swift
//  Painter
//
//  Created by Ramasamy S I on 22/03/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

#if os(macOS)
import AppKit.NSAttributedString
#elseif os(iOS) || os(tvOS) || os(watchOS)
import UIKit.NSAttributedString
#endif

public extension NSAttributedString.Key {
	static let zsTextCase = NSAttributedString.Key("zsTextCase")
	static let zsIsBullet = NSAttributedString.Key("zsIsBullet")
	static let zsListParaStyle = NSAttributedString.Key("zsListParaStyle")
	static let originalFont = NSAttributedString.Key("NSOriginalFont")
	static let zsFontFamilyInProto = NSAttributedString.Key("zsFontFamilyInProto")
	static let zsFontSizeWithoutBaseline = NSAttributedString.Key("zsFontSizeWithoutBaseline")
	static let zsTextLayerProps = NSAttributedString.Key("zsTextLayerProps")
	static let zsCharacterStyleRef = NSAttributedString.Key("zsCharacterStyleRef")
	static let zsCharacterParaStyleRef = NSAttributedString.Key("zsCharacterParaStyleRef")
	static let zsHyperLinkColor = NSAttributedString.Key("zsHyperLinkColor")
	static let zsHyperLinkUnderLine = NSAttributedString.Key("zsHyperLinkUnderLine")
	static let zsHyperLinkData = NSAttributedString.Key("zsHyperLinkData")
	static let zsDataFieldsBGColor = NSAttributedString.Key("zsDataFieldsBGColor")
	static let zsHighlightBGColor = NSAttributedString.Key("zsHighlightBGColor")
	static let zsTempTextSelectionBGColor = NSAttributedString.Key("zsTempTextSelectionBGColor")
}

public extension NSAttributedString {
	/// Utility property to get entire range(NSRange) of attributed string
	var fullRange: NSRange {
		return NSRange(location: 0, length: self.length)
	}

	/// Utility property that computes maximum font size available
	var maxFontSize: CGFloat {
		var maxSize: CGFloat = 0
		self.enumerateAttributes(in: self.fullRange) { attributes, _, _ in
			let isBullet = attributes[.zsIsBullet] as? Bool
			if isBullet == nil || isBullet == false, let font = attributes[.font] as? DeviceFont {
				var fontSize = font.pointSize
				if let actualFontSize = attributes[.zsFontSizeWithoutBaseline] as? CGFloat {
					fontSize = actualFontSize
				}
				maxSize = max(maxSize, fontSize)
			}
		}
		return maxSize
	}

	func isValidSubRange(_ range: NSRange) -> Bool {
		let fullRange = self.fullRange
		if range.location != NSNotFound,
		   range.location >= 0,
		   NSMaxRange(range) <= fullRange.length {
			return range.intersection(fullRange) != nil
		}
		return false
	}

	// The below function restricts from crashes due to incorrect range given for getting attributedsubstring
	func getAttributedSubString(from range: NSRange) -> NSAttributedString? {
		guard self.isValidSubRange(range) else {
			Debugger.debug("Incorrect range \(range) received to compute subString from \(self)")
			return nil
		}
		return self.attributedSubstring(from: range)
	}

	/// NSAttributedString to 'TextBody' conversion
	var textBody: TextBody {
		var newTextBody = TextBody()
		var paragraph = Paragraph()
		let enumerationRange = NSRange(location: 0, length: self.length)

		self.enumerateAttributes(in: enumerationRange, options: .init(rawValue: 0)) { chunkAttributes, chunkRange, _ in
			let portions = self.makePortions(from: chunkAttributes, for: chunkRange)

			self.setParaStyle(for: &paragraph, from: chunkAttributes)
			for portion in portions {
				self.splitAndMerge(portion, and: &paragraph, to: &newTextBody)
			}
		}
		if !paragraph.isEqualTo(message: Paragraph()) {
			newTextBody.paras.append(paragraph) // Append last 'Paragraph' instance to 'TextBody'
		}
		newTextBody.props = TextBoxProps.default
		return newTextBody
	}

	/// Applies text case conversion to contents based on the text case type
	var casedAttributedString: NSMutableAttributedString {
		let attributedString = NSMutableAttributedString(attributedString: self)
		attributedString.beginEditing()
		self.enumerateAttributes(in: self.fullRange) { attributes, range, _ in
			if let textcase = attributes[.zsTextCase] as? Int, let subString = self.getAttributedSubString(from: range)?.string {
				switch textcase {
				case 0:
					attributedString.replaceCharacters(in: range, with: subString.lowercased())
				case 1:
					attributedString.replaceCharacters(in: range, with: subString.uppercased())
				case 2:
					break
				case 3:
					// FIXME: What if capitalize starts in between a word.
					// A letter that is not first letter in the word will captialized. This shouldn't happen.
					attributedString.replaceCharacters(in: range, with: subString.capitalized)
				default:
					break
				}
			}
		}
		attributedString.endEditing()
		return attributedString
	}

	/// Plain string with text case conversion applied
	var casedString: String {
		return self.casedAttributedString.string
	}

	func getMaxDefaultLineHeight(forRange range: NSRange) -> CGFloat {
		return self.getDefaultLineHeights(forRange: range).max() ?? 0.0
	}

	func getDefaultLineHeights(forRange range: NSRange) -> [CGFloat] {
		var lineHeights = Set<CGFloat>()
		enumerateAttribute(.font, in: range) { value, _, _ in
#if os(macOS)
			if let font = value as? NSFont {
				let defaultHeight = ZSLayoutManager.defaultLineHeight(for: font)
				lineHeights.insert(defaultHeight)
			}
#else
			if let font = value as? UIFont {
				let defaultHeight = font.lineHeight
				lineHeights.insert(defaultHeight)
			}
#endif
		}
		return Array(lineHeights)
	}

#if !os(watchOS)
	func getMaxBaselineOffset(range: NSRange) -> (baselineOffset: CGFloat, font: DeviceFont) {
		var maxBaselineOffset = -CGFloat.greatestFiniteMagnitude
		var correspondingFont = DeviceFont.systemFont(ofSize: 12)

		self.enumerateAttribute(.font, in: range) { value, _, _ in
			if let font = value as? DeviceFont {
#if os(macOS)
				let defaultBaselineOffset = ZSLayoutManager.defaultBaselineOffset(for: font)
#else
				let defaultBaselineOffset = font.baselineOffset
#endif
				if defaultBaselineOffset > maxBaselineOffset {
					maxBaselineOffset = defaultBaselineOffset
					correspondingFont = font
				}
			}
		}
		return (maxBaselineOffset, correspondingFont)
	}

	func getMaxDescender(forRange range: NSRange) -> (descender: CGFloat, font: DeviceFont) {
		var maxDescender = -CGFloat.greatestFiniteMagnitude
		var correspondingFont = DeviceFont.systemFont(ofSize: 12)

		self.enumerateAttribute(.font, in: range) { value, _, _ in
			if let font = value as? DeviceFont {
#if os(macOS)
				let descender = ZSLayoutManager.defaultBaselineOffset(for: font)
#else
				let descender = font.descender
#endif
				if descender > maxDescender {
					maxDescender = descender
					correspondingFont = font
				}
			}
		}
		return (maxDescender, correspondingFont)
	}
#endif
}

// MARK: Texbody Construction Helpers

private extension NSAttributedString {
	/// Translate attributes given into 'Parastyle' and assign it to given 'Paragraph'
	func setParaStyle(for paragraph: inout Paragraph, from attributes: [NSAttributedString.Key: Any]) {
		paragraph.style = ParaStyle.default

		let hAlignMap: [NSTextAlignment: HorizontalAlignType] = [
			.left: .left,
			.right: .right,
			.center: .center,
			.justified: .left,
			.natural: .left
		]

		if let paraStyle = attributes[.paragraphStyle] as? NSParagraphStyle { // Paragraph Style
			if let halign = hAlignMap[paraStyle.alignment] {
				paragraph.style.halign = halign // Horizontal Alignment
			}

			var before = ParaStyle.Spacing.SpacingValue()
			if paraStyle.paragraphSpacingBefore != 0.0 {
				before.type = .absolute
				before.absolute = Float(paraStyle.paragraphSpacingBefore)
				paragraph.style.spacing.before = before // Paragraph Spacing Before
			} else {
				paragraph.style.spacing.clearBefore()
			}

			var after = ParaStyle.Spacing.SpacingValue()
			if paraStyle.paragraphSpacing != 0.0 {
				after.type = .absolute
				after.absolute = Float(paraStyle.paragraphSpacing)
				paragraph.style.spacing.after = after // Paragraph Spacing After
			} else {
				paragraph.style.spacing.clearAfter()
			}

			paragraph.style.setLineSpacing(usingSystemParaStyle: paraStyle)

			// Clear 'spacing' value in 'Parastyle' if none of the above spacing is present in attributes string
			if !paragraph.style.spacing.hasLine, !paragraph.style.spacing.hasBefore, !paragraph.style.spacing.hasAfter {
				paragraph.style.clearSpacing()
			}
#if os(macOS)
			paragraph.style.setCharacterStyleRef(attributes)
#endif
		}

		if let zsParaStyle = attributes[.zsListParaStyle] as? ParaStyle {
			paragraph.style = zsParaStyle
		}
	}

	/// Split current 'Portion' instance into multiple 'Paragraph' instances if newLine character is present
	func splitAndMerge(_ portion: Portion, and paragraph: inout Paragraph, to newTextBody: inout TextBody) {
		if portion.hasT, portion.t.contains("\n") {
			let portionStrings = portion.t.components(separatedBy: "\n")
			if portion.t.contains("\n"), portionStrings.count > 1 {
				for index in 0..<portionStrings.count {
					let portionString = portionStrings[index]
					if !portionString.isEmpty {
						var partialPortion = Portion()
						partialPortion = portion // A copy of current 'Portion' instance
						partialPortion.t = portionString // Change 't' (contents) of copied 'Portion' instance
						paragraph.portions.append(partialPortion)
					}

					if index == (portionStrings.count - 1) {
						if portionString.isEmpty {
							paragraph = Paragraph() // Create fresh 'Paragraph' instance
						}
					} else {
						// An empty 'Portion' has to be added for an empty 'Paragraph' to retain 'PortionProps' and 'ParaStyle'
						if paragraph.portions.isEmpty, portionString.isEmpty { // Series of '\n' Characters in current Chunk of AttributedString
							var emptyPortion = Portion()
							emptyPortion = portion
							emptyPortion.t = ""
							paragraph.portions.append(emptyPortion)
						}
						newTextBody.paras.append(paragraph)
						paragraph.portions.removeAll() // Remove portions alone; Persist para props
					}
				}
			} else { // End of current 'Paragraph' instance
				paragraph.portions.append(portion) // Append last 'Portion' to current 'Paragraph' instance
				newTextBody.paras.append(paragraph) // Append current 'Paragraph' instance to 'TextBody'
				paragraph = Paragraph() // Create fresh 'Paragraph' instance
			}
		} else { // Keep appending portions to same 'Paragraph' instance
			paragraph.portions.append(portion)
		}
	}
}

public extension NSMutableParagraphStyle {
	func setAbsoluteLineHeight(_ value: CGFloat) {
		self.minimumLineHeight = value
		self.maximumLineHeight = value
	}
}

extension NSAttributedString {
	// MARK: methods to compute baseline position

#if !os(watchOS)
	func getPositionOfBaseLineOfFirstLine() -> Float {
		guard self.length != 0 else {
			return -1
		}
		let firstParaRange = self.getFirstParaRange()
		let defaultBaselineOffset = self.getDefaultBaseLineOffset(paraRange: firstParaRange)
		var firstLineBaselinePosition = defaultBaselineOffset
		let defaultLineHeight = self.getDefaultLineHeight(paraRange: firstParaRange)
		let paraStyle = self.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle ?? NSParagraphStyle.default
		let absoluteLineHeight = paraStyle.absoluteLineHeight == 0 ? defaultLineHeight : Float(paraStyle.absoluteLineHeight)
		let lineHeightDiff = absoluteLineHeight - defaultLineHeight
		if lineHeightDiff >= 0 {
			firstLineBaselinePosition += (lineHeightDiff / 2)
		}
		return firstLineBaselinePosition
	}

	func getDefaultLineHeight(paraRange: NSRange) -> Float {
		let maxDefaultLineHeight = self.getMaxDefaultLineHeight(forRange: paraRange)
		return Float(maxDefaultLineHeight)
	}

	func getDefaultBaseLineOffset(paraRange: NSRange) -> Float {
		let maxBaseLineOffset = self.getMaxBaselineOffset(range: paraRange)
		return Float(maxBaseLineOffset.baselineOffset)
	}

	func getFirstParaRange() -> NSRange {
		guard self.length != 0 else {
			return NSRange(location: 0, length: 0)
		}
		let charRange = NSRange(location: 0, length: 1)
		let paraRange = NSString(string: self.string).paragraphRange(for: charRange)
		return paraRange
	}
#endif

	func getParaStyle(from attributes: [NSAttributedString.Key: Any]) -> ParaStyle {
		var paragraphStyle = ParaStyle.default

		let hAlignMap: [NSTextAlignment: HorizontalAlignType] = [
			.left: .left,
			.right: .right,
			.center: .center,
			.justified: .left,
			.natural: .left
		]

		if let paraStyle = attributes[.paragraphStyle] as? NSParagraphStyle { // Paragraph Style
			if let halign = hAlignMap[paraStyle.alignment] {
				paragraphStyle.halign = halign // Horizontal Alignment
			}

			var before = ParaStyle.Spacing.SpacingValue()
			if paraStyle.paragraphSpacingBefore != 0.0 {
				before.type = .absolute
				before.absolute = Float(paraStyle.paragraphSpacingBefore)
				paragraphStyle.spacing.before = before // Paragraph Spacing Before
			} else {
				paragraphStyle.spacing.clearBefore()
			}

			var after = ParaStyle.Spacing.SpacingValue()
			if paraStyle.paragraphSpacing != 0.0 {
				after.type = .absolute
				after.absolute = Float(paraStyle.paragraphSpacing)
				paragraphStyle.spacing.after = after // Paragraph Spacing After
			} else {
				paragraphStyle.spacing.clearAfter()
			}

			paragraphStyle.setLineSpacing(usingSystemParaStyle: paraStyle)

			// Clear 'spacing' value in 'Parastyle' if none of the above spacing is present in attributes string
			if !paragraphStyle.spacing.hasLine, !paragraphStyle.spacing.hasBefore, !paragraphStyle.spacing.hasAfter {
				paragraphStyle.clearSpacing()
			}
		}
		return paragraphStyle
	}

	public func makePortions(
		from attributes: [NSAttributedString.Key: Any],
		for range: NSRange) -> [Portion] {
		// MARK: - Till now only data fields have background. If BG is introduced, need to change the below code

		if attributes[.zsDataFieldsBGColor] != nil,
		   let attributedSubString = self.getAttributedSubString(from: range),
		   attributedSubString.hasDataField {
			let portionsRange = self.splitDataFieldPortions(
				subString: attributedSubString.string,
				originalRange: range)
			return portionsRange.compactMap { currentRange in
				self.makePortion(from: attributes, for: currentRange)
			}
		} else {
			return [self.makePortion(from: attributes, for: range)]
		}
	}

	/// Build a new 'Portion' object out of a substring of actual AttributedString
	func makePortion(
		from localAttributes: [NSAttributedString.Key: Any],
		for range: NSRange) -> Portion {
		var portion = Portion.default
		var attributes = localAttributes
		if let attributedSubString = self.getAttributedSubString(from: range) {
			if attributes[.zsDataFieldsBGColor] != nil,
			   attributedSubString.hasDataField {
				// Additional check to only enter if it is in data fields format
				// Case only happens when portion is a datafield
				if let dfName = attributedSubString.computeDataFieldName {
					portion.type = .field
					portion.field.type = .datafield
					portion.field.datafieldID = dfName
				} else {
					portion.t = attributedSubString.string
				}
			} else {
				portion.t = attributedSubString.string
			}
		}
		portion.props.setHyperLinkProperties(&attributes, in: range)

		portion.props.setColorProperties(attributes)
#if os(macOS)
		portion.props.setCharacterStyleRef(attributes)
#endif

		if let font = attributes[.font] as? DeviceFont { // Font family and Font size
			portion.props.setFont(font)

			let fontSize = PainterConfig.actualPortionFontSize(forSize: Float(font.pointSize))
			if let baselineValue = attributes[.baselineOffset] as? Float { // Baseline
				portion.props.baseline = baselineValue / fontSize
				portion.props.size = fontSize / 0.63
			} else {
				portion.props.size = fontSize
			}
		}

		if let underline = attributes[.underlineStyle] as? Int { // Underline
			portion.props.underline = (underline == 1) ? .single : .none
		}

		if let strikethrough = attributes[.strikethroughStyle] as? Int { // Strikethrough
			portion.props.strike = (strikethrough == 1) ? .single : .none
		}

		if let kern = attributes[.kern] as? Double { // Kerning (Character Spacing)
			portion.props.space = Float(kern)
		}

		if let textcase = attributes[.zsTextCase] as? Int {
			portion.props.cap = PortionField.FontVariant(rawValue: textcase) ?? .none
		}
		return portion
	}
}

private extension NSAttributedString {
	var hasDataField: Bool {
		let inputString = self.string
		let pattern = ".*\\$\\(.*\\).*"
		return inputString.range(of: pattern, options: .regularExpression) != nil
	}

	var computeDataFieldName: String? {
		let string = self.string
		guard
			let firstIndex = string.firstIndex(of: "$"),
			let lastIndex = string.lastIndex(of: ")")
		else {
			return nil
		}

		/*
		 An example of the case
		 $(ABC)\n
		 startIndex is 0
		 endIndex is 5
		 location is 2
		 length is 5 - 2 = 3
		 */

		let startIndex = string.distance(from: string.startIndex, to: firstIndex)
		let endIndex = string.distance(from: string.startIndex, to: lastIndex)
		let location = (startIndex + 2)
		let length = (endIndex - location)
		let newRange = NSRange(location: location, length: length)
		guard let newSubString = self.getAttributedSubString(from: newRange)?.string else {
			return nil
		}
		return newSubString
	}

	func splitDataFieldPortions(subString: String, originalRange: NSRange) -> [NSRange] {
		var dfNamesArr = [String]()
		var splittedRanges = [NSRange]()

		let nameSplitted = subString.split(separator: ")")
		for name in nameSplitted {
			let firstCharIndex = subString.index(subString.startIndex, offsetBy: 0) // Replace 7 with your desired index
			let secondCharIndex = subString.index(subString.startIndex, offsetBy: 1)
			let charAtFirstIndex = subString[firstCharIndex]
			let charAtSecondIndex = subString[secondCharIndex]
			if charAtFirstIndex == "$", charAtSecondIndex == "(" {
				dfNamesArr.append(name + ")")
			} else if !dfNamesArr.isEmpty {
				let prevDFName = dfNamesArr.removeLast()
				dfNamesArr.append(prevDFName + name + ")")
			}
		}
		var tempStartIndex = originalRange.lowerBound
		for dfName in dfNamesArr {
			let len = dfName.count
			let newRange = NSRange(location: tempStartIndex, length: len)
			splittedRanges.append(newRange)
			tempStartIndex += len
		}
		return splittedRanges
	}
}

extension PortionProps {
	mutating func setCharacterStyleRef(_ attributes: [NSAttributedString.Key: Any]) {
		if let characterStyleRef = attributes[.zsCharacterStyleRef] as? StyleReferenceDetails {
			self.styleRef = characterStyleRef
		}
	}

	mutating func setHyperLinkProperties(
		_ attributes: inout [NSAttributedString.Key: Any],
		in range: NSRange) {
		if let hyperlinkData = attributes[.zsHyperLinkData] as? Proto.HyperLink {
			self.click = hyperlinkData
		}
		if let hyperlinkUnderline = attributes[.zsHyperLinkUnderLine] as? NSNumber,
		   let underline = attributes[.underlineStyle] as? NSNumber {
			attributes[.zsHyperLinkUnderLine] = underline
			attributes[.underlineStyle] = hyperlinkUnderline
		}
		if let someData = attributes[.link] {
			// telephone also gets added in link when copied from keynote
			var linkData = String(describing: someData)
			if linkData.starts(with: "tel:") {
				return
			}
			var hyperlink = HyperLink()
			if linkData.starts(with: "mailto:") {
				// Email type

				// Remove the prefix "mailto:"
				linkData.removeFirst(7)

				let splittedStrings = linkData.components(separatedBy: "?subject=")
				if splittedStrings.count > 1 {
					// Its a email
					var email = HyperLink.Email()
					email.address = String(splittedStrings[0])
					email.subject = String(splittedStrings[1])
					hyperlink.email = email
					hyperlink.type = .email
				} else {
					return
				}
			} else {
				// Its a link
				hyperlink.link = String(linkData)
				hyperlink.type = .link
			}
			self.click = hyperlink
		}
	}
}

extension ParaStyle {
	mutating func setCharacterStyleRef(_ attributes: [NSAttributedString.Key: Any]) {
		if let characterStyleRef = attributes[.zsCharacterParaStyleRef] as? StyleReferenceDetails {
			self.styleRef = characterStyleRef
		}
	}
}

#if !os(macOS)
extension UIFont {
	var baselineOffset: CGFloat {
		// FIXME: Not sure if ascender is excatly the baseline offset.
		return self.ascender
	}
}
#endif
