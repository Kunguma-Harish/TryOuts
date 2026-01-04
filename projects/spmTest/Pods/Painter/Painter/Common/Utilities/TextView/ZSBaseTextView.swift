//
//  ZSBaseTextView.swift
//  Painter
//
//  Created by Ramasamy S I on 04/08/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

#if !os(watchOS)
import GraphikosAppleAssets
#if os(macOS)
import AppKit.NSTextStorage
#else
import UIKit.NSTextStorage
#endif
import Proto

extension DeviceFont {
	var deviceFamilyName: String {
#if os(macOS)
		// NOTE: Family name for a font will be available in most of the scenarios
		// If a font doesn't have a familyName, use it's fontName
		return self.familyName ?? self.fontName
#else
		return self.familyName
#endif
	}
}

public class ZSBaseTextView: PlatformTextView {
	public let initialFrame: CGRect
	var config: PainterConfig?

	init(
		frame: CGRect,
		delegate: ZSTextViewDelegate?,
		textContainer: NSTextContainer,
		config: PainterConfig? = nil) {
		self.config = config
		self.initialFrame = frame
		super.init(frame: frame, textContainer: textContainer)
		self.delegate = delegate
		self.setDefaults()
	}

	override init(frame: CGRect, textContainer: NSTextContainer?) {
		self.initialFrame = frame
		super.init(frame: frame, textContainer: textContainer)
		self.setDefaults()
	}

	@available(*, unavailable)
	required init? (coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

#if os(macOS)
	override public func cancelOperation(_ sender: Any?) {
		(self.delegate as? ZSTextViewDelegate)?.stopTextEditing()
	}
#endif

	public var textViewCursorColor: DeviceColor {
#if os(macOS)
		return self.insertionPointColor
#else
		return self.tintColor
#endif
	}

	public func updateTextStorage(
		inRanges ranges: [NSRange],
		with batchUpdates: (NSMutableAttributedString, [NSRange]) -> Void) {
#if os(macOS)
		// TODO: Find if there are corresponding methods for iOS.
		if self.shouldChangeText(inRanges: ranges as [NSValue], replacementStrings: nil),
		   let stringToUpdate = self.textStorage {
			stringToUpdate.beginEditing()
			batchUpdates(stringToUpdate, ranges)
			stringToUpdate.endEditing()
			self.didChangeText()
		}
#else
		self.textStorage.beginEditing()
		batchUpdates(self.textStorage, ranges)
		self.textStorage.endEditing()
		let beginning: UITextPosition = self.beginningOfDocument
		if let start = self.position(from: beginning, offset: self.selectedRange.location),
		   let end = self.position(from: start, offset: self.selectedRange.length),
		   let textRange = self.textRange(from: start, to: end) {
			self.selectedTextRange = textRange
			let location = self.offset(from: self.beginningOfDocument, to: textRange.start)
			let length = self.offset(from: textRange.start, to: textRange.end)
			self.selectedRange = NSRange(location: location, length: length)
		}
#endif
	}

	public func changeHorizontalTextAlignment(to hAlign: HorizontalAlignType, over ranges: [NSRange]? = nil) {
		let textAlign = hAlign.alignment
		let paraRanges = ranges ?? self.getParagraphRangesOfSelection()

		self.updateTextStorage(inRanges: paraRanges) { textStorage, ranges in
#if os(macOS)
			for range in ranges {
				self.setAlignment(textAlign, range: range)
			}
#else
			for range in ranges {
				textStorage.enumerateAttribute(.paragraphStyle, in: range) { value, valueRange, _ in
					if let currentParagraphStyle = value as? NSParagraphStyle {
						let paragraphStyle = NSMutableParagraphStyle() // Must create new instance or else 'ParagraphStyle' of entire attributed string will be affected
						paragraphStyle.setParagraphStyle(currentParagraphStyle) // Retain existing 'ParagraphStyle'
						paragraphStyle.alignment = textAlign
						textStorage.addAttribute(.paragraphStyle, value: paragraphStyle, range: valueRange)
					}
				}
			}
#endif
		}

		// Setting typing attributes for alignment explicitly as it is not getting updated after calling 'setAlignment' method.
		if let paraStyle = self.typingAttributes[.paragraphStyle] as? NSMutableParagraphStyle {
			let typingParaStyle = NSMutableParagraphStyle()
			typingParaStyle.setParagraphStyle(paraStyle)
			typingParaStyle.alignment = textAlign
			self.typingAttributes[.paragraphStyle] = typingParaStyle
		}
	}

	public func changeTextColor(to color: DeviceColor, over ranges: [NSRange]? = nil) {
		self.typingAttributes[.foregroundColor] = color
		guard ranges != nil || !self.selectionIsForTypingAttributes else {
			return
		}
		let rangesToModify = ranges ?? self.textContent.selectedRanges
		self.updateTextStorage(inRanges: rangesToModify) { textStorage, selectedRanges in
			for range in selectedRanges {
				textStorage.enumerateAttribute(.foregroundColor, in: range) { _, colorRange, _ in
					textStorage.addAttribute(.foregroundColor, value: color, range: colorRange)
				}
			}
		}
	}

	public func changeTempSelectionBackgroundColor(
		to color: DeviceColor,
		over ranges: [NSRange]? = nil) {
		let textRange = self.textContent.attributedString.fullRange
		let rangesToModify = ranges ?? [textRange]
		self.updateTextStorage(inRanges: rangesToModify) { textStorage, selectedRanges in
			for range in selectedRanges {
				/*
				 Need to update the background color attribute with the textColor for hyperlink when focus changes.
				 There are 2 cases.
				 Case 1: When text only no background. In this case need to directly add the color
				 Case 2: When text has background (either highlight, data field or datafield + highlight). In this case need to blend backgrond color with new color and set it to background color.

				 We save the value of old background color in the attribute zsTempTextSelectionColor if present
				 */
				textStorage.addAttribute(
					.zsTempTextSelectionBGColor,
					value: color,
					range: range)
				textStorage.enumerateAttribute(.backgroundColor, in: range) { newColor, subRange, _ in
					guard let newBGColor = newColor as? DeviceColor else {
						return
					}
					textStorage.addAttribute(
						.zsTempTextSelectionBGColor,
						value: newBGColor,
						range: subRange)
				}

				// We compute the new background color with blended color
				textStorage.enumerateAttribute(.zsTempTextSelectionBGColor, in: range) { color, subRange, _ in
					guard let oldBGColor = color as? DeviceColor else {
						return
					}
					var blendedColor = self.textViewCursorColor
					if oldBGColor != blendedColor {
						blendedColor = oldBGColor.blend(with: blendedColor, alpha: 0.2)
					}
					textStorage.addAttribute(
						.backgroundColor,
						value: blendedColor,
						range: subRange)
				}
			}
		}
	}

	public func removeTempSelectionBackgroundColor(over ranges: [NSRange]? = nil) {
		let textRange = self.textContent.attributedString.fullRange
		let rangesToModify = ranges ?? [textRange]
		self.updateTextStorage(inRanges: rangesToModify) { textStorage, selectedRanges in
			for range in selectedRanges {
				textStorage.enumerateAttribute(.zsTempTextSelectionBGColor, in: range) { color, subRange, _ in
					guard let oldColor = color as? DeviceColor else {
						textStorage.removeAttribute(.zsTempTextSelectionBGColor, range: subRange)
						return
					}
					if oldColor == self.textViewCursorColor.withAlphaComponent(0.2) {
						textStorage.removeAttribute(.backgroundColor, range: subRange)
					} else {
						textStorage.addAttribute(.backgroundColor, value: oldColor, range: subRange)
					}
					textStorage.removeAttribute(.zsTempTextSelectionBGColor, range: subRange)
				}
			}
		}
	}

	public func changeHyperLinkUnderline(
		for type: HyperLink.LinkType,
		to lineType: LineType,
		over ranges: [NSRange]? = nil) {
		let rangesToModify = ranges ?? self.textContent.selectedRanges
		let underlineValue = NSNumber(value: lineType.underlineStyle.rawValue)

		if type != .none, underlineValue != 0 {
			var rangesToUpdate: [NSRange] = []
			self.updateTextStorage(inRanges: rangesToModify) { textStorage, selectedRanges in
				for range in selectedRanges {
					textStorage.enumerateAttribute(.underlineStyle, in: range) { underLine, underLineRange, _ in
						rangesToUpdate.append(underLineRange)
						if underLine != nil {
							textStorage.addAttribute(.zsHyperLinkUnderLine, value: underLine as Any, range: underLineRange)
						}
					}
				}
			}
			self.updateTextStorage(inRanges: rangesToUpdate) { textStorage, selectedRanges in
				for range in selectedRanges {
					textStorage.addAttribute(.underlineStyle, value: underlineValue, range: range)
				}
			}
		} else {
			self.updateTextStorage(inRanges: rangesToModify) { textStorage, selectedRanges in
				for range in selectedRanges {
					textStorage.enumerateAttribute(.zsHyperLinkUnderLine, in: range) { underLine, underLineRange, _ in
						textStorage.removeAttribute(.underlineStyle, range: underLineRange)
						guard let underLineValue = underLine as? Int64 else {
							return
						}
						textStorage.addAttribute(.underlineStyle, value: underLineValue as Any, range: underLineRange)
					}
				}
			}
		}
	}

	public func changeHyperLinkTextColor(
		for type: HyperLink.LinkType,
		to hyperLinkColor: DeviceColor,
		over ranges: [NSRange]? = nil) {
		let rangesToModify = ranges ?? self.textContent.selectedRanges
		if type != .none {
			var rangesToUpdate: [NSRange] = []
			self.updateTextStorage(inRanges: rangesToModify) { textStorage, selectedRanges in
				for range in selectedRanges {
					textStorage.enumerateAttribute(.foregroundColor, in: range) { color, colorRange, _ in
						rangesToUpdate.append(colorRange)
						textStorage.addAttribute(.zsHyperLinkColor, value: color as Any, range: colorRange)
					}
				}
			}
			self.updateTextStorage(inRanges: rangesToUpdate) { textStorage, selectedRanges in
				for range in selectedRanges {
					textStorage.addAttribute(.foregroundColor, value: hyperLinkColor, range: range)
				}
			}
		} else {
			self.updateTextStorage(inRanges: rangesToModify) { textStorage, selectedRanges in
				for range in selectedRanges {
					textStorage.enumerateAttribute(.zsHyperLinkColor, in: range) { color, colorRange, _ in
						guard let textColor = color as? DeviceColor else {
							return
						}
						textStorage.addAttribute(.foregroundColor, value: textColor, range: colorRange)
						textStorage.removeAttribute(.zsHyperLinkColor, range: colorRange)
					}
				}
			}
		}
	}

	public func changeHighlightColor(
		to highlightColor: DeviceColor?,
		over ranges: [NSRange]? = nil) {
		let rangesToModify = ranges ?? self.textContent.selectedRanges
		if let highlightColor {
			guard ranges != nil || !self.selectionIsForTypingAttributes else {
				typingAttributes[.zsHighlightBGColor] = highlightColor
				return
			}
			self.updateTextStorage(inRanges: rangesToModify) { textStorage, selectedRanges in
				for range in selectedRanges {
					textStorage.addAttribute(.zsHighlightBGColor, value: highlightColor, range: range)
				}
			}
		} else {
			guard ranges != nil || !self.selectionIsForTypingAttributes else {
				typingAttributes.removeValue(forKey: .zsHighlightBGColor)
				return
			}
			self.updateTextStorage(inRanges: rangesToModify) { textStorage, selectedRanges in
				for range in selectedRanges {
					textStorage.removeAttribute(.zsHighlightBGColor, range: range)
				}
			}
		}
	}

	public func updateBackgroundColor(
		over ranges: [NSRange]?,
		highlightColor: DeviceColor?,
		dataFieldBGColor dfColor: DeviceColor) {
		let rangesToModify = ranges ?? self.textContent.selectedRanges
		self.updateTextStorage(inRanges: rangesToModify) { textStorage, selectedRanges in
			for range in selectedRanges {
				textStorage.enumerateAttribute(.zsDataFieldsBGColor, in: range) { color, subRange, _ in
					if color != nil {
						if let highlightColor {
							let newColor = highlightColor.blend(with: dfColor, alpha: 0.3)
							textStorage.addAttribute(.backgroundColor, value: newColor, range: subRange)
						} else {
							textStorage.addAttribute(.backgroundColor, value: dfColor, range: subRange)
						}
					} else {
						if let highlightColor {
							textStorage.addAttribute(.backgroundColor, value: highlightColor, range: subRange)
						} else {
							textStorage.removeAttribute(.backgroundColor, range: subRange)
						}
					}
				}
			}
		}
	}

	func changeTypeface(to familyName: String, over ranges: [NSRange]? = nil) {
		guard
			let currentFont = self.typingAttributes[.font] as? DeviceFont,
			let newFont = self.getNewFont(for: currentFont, withFamily: familyName)
		else {
			assertionFailure("Font attribute not set or can't get new font for current font")
			return
		}
		self.typingAttributes[.font] = newFont
	}
}

public extension ZSBaseTextView {
	var textContent: (attributedString: NSMutableAttributedString, selectedRanges: [NSRange]) {
#if os(macOS)
		return (
			attributedString: NSMutableAttributedString(attributedString: self.attributedString()),
			selectedRanges: self.selectedRanges.map { $0.rangeValue })
#else
		return (
			attributedString: NSMutableAttributedString(attributedString: self.attributedText),
			selectedRanges: [self.selectedRange])
#endif
	}

	var selectionIsForTypingAttributes: Bool {
		let selectedRanges = self.textContent.selectedRanges
		return selectedRanges.count == 1 && selectedRanges[0].length == 0
	}

	func getParagraphRangesOfSelection() -> [NSRange] {
		var paraRanges = [NSRange]()
		let text = self.textContent
		for range in text.selectedRanges {
			let paraRange = (text.attributedString.string as NSString).paragraphRange(for: range)
			paraRanges.append(paraRange)
		}
		return paraRanges
	}

	func makeSelectionInTextView(
		at point: CGPoint?,
		by selectOption: PlatformTextGranularity?) {
		if let point = point, let selectOption = selectOption {
#if os(macOS)
			var fractionDistance: CGFloat = 0
			if let textContainer = self.textContainer,
			   var charIndex = self.layoutManager?.characterIndex(
			   	for: point,
			   	in: textContainer,
			   	fractionOfDistanceBetweenInsertionPoints: &fractionDistance) {
				if fractionDistance >= 0.5,
				   let textStorage = self.textStorage,
				   (charIndex + 1) <= textStorage.length {
					charIndex += 1
				}
				let selectionRange = self.selectionRange(
					forProposedRange: NSRange(location: charIndex, length: 0),
					granularity: selectOption)
				self.setSelectedRange(selectionRange)
			}
#else
			if let textPosition = self.closestPosition(to: point) {
				if selectOption == .word {
					self.selectedTextRange = self.tokenizer.rangeEnclosingPosition(
						textPosition,
						with: selectOption,
						inDirection: .storage(.forward))
				} else { // Character based selection by default
					var range: UITextRange?
					if let textPosition = self.tokenizer.position(
						from: textPosition,
						toBoundary: .character,
						inDirection: .storage(.forward)) {
						range = self.textRange(from: textPosition, to: textPosition)
					} else {
						let endOfDocument = self.endOfDocument
						range = self.textRange(from: endOfDocument, to: endOfDocument)
					}
					self.selectedTextRange = range
				}
			}
#endif
		} else {
			let attributedString = self.textContent.attributedString
			self.setSelectionRanges([attributedString.fullRange])
		}
	}

	func endEditingAndRemoveView() {
		self.undoManager?.removeAllActions(withTarget: self)
		self.undoManager?.removeAllActions(withTarget: self.textStorage as Any)
		self.removeFromSuperview()
	}

	func getMaxDefaultLineHeightForSelection() -> CGFloat {
		return self.getDefaultLineHeightsForSelection().max() ?? 0.0
	}

	func getDefaultLineHeightsForSelection() -> [CGFloat] {
		let paraRanges = self.getParagraphRangesOfSelection()
		var defaultLineHeights = Set<CGFloat>()
		for range in paraRanges {
			defaultLineHeights.formUnion(self.textContent.attributedString.getDefaultLineHeights(forRange: range))
		}
		return Array(defaultLineHeights)
	}
}

private extension ZSBaseTextView {
	func setDefaults() {
		self.backgroundColor = .clear
		self.textContainerInset = .zero

#if os(macOS)
		self.usesInspectorBar = false
		self.usesRuler = false
		self.isRulerVisible = false
		self.allowsUndo = true
		self.isAutomaticQuoteSubstitutionEnabled = true
#else
		self.smartQuotesType = .no
		self.smartDashesType = .no
		self.smartInsertDeleteType = .no
		self.clipsToBounds = false
		self.isScrollEnabled = false
		self.spellCheckingType = .no
#endif
	}

	func setSelectionRanges(_ ranges: [NSRange]) {
#if os(macOS)
		self.selectedRanges = ranges.map { NSValue(range: $0) }
#else
		if ranges.count == 1 {
			self.selectedRange = ranges[0]
		} else {
			assertionFailure("UITextView can hold only one continuous selection range.")
		}
#endif
	}
}

// MARK: - Change TextStorage attributes

extension ZSBaseTextView {
	func getNewFont(for oldFont: DeviceFont, withFamily family: String) -> DeviceFont? {
		var newFont: DeviceFont?

#if os(macOS)
		// NSFontManager APIs in macOS are far more reliable and easier than the decriptor APIs.
		// Example:
		// 		Switch from Roboto to SF Pro Text with 'Medium' weight.
		// 		NSFontManager will preserve the weight, whereas descriptor APIs won't.
		// 		Tested with macOS 10.15.6
		newFont = NSFontManager.shared.convert(oldFont, toFamily: family)
#else
		let familyName = FontHandler.shared.modifiedFamilyName(forFontFamily: family)
		if let fontDescriptor = oldFont.fontDescriptor.withFace(familyName)
			.withSymbolicTraits(oldFont.fontDescriptor.symbolicTraits) {
			newFont = DeviceFont(descriptor: fontDescriptor, size: oldFont.pointSize)
		}

		// Get a default font with given family name if matching font is not available.
		if newFont == nil {
			let descriptor = PlatformFontDescriptor(fontAttributes: [.family: familyName])
			newFont = DeviceFont(descriptor: descriptor, size: oldFont.pointSize)
		}
#endif

		return newFont
	}

	func updateParaStyle(
		in textStorage: NSMutableAttributedString,
		over range: NSRange,
		with newLineSpaces: inout [CGFloat],
		ofType type: ParaStyle.Spacing.SpacingValue.SpacingValueType,
		isCommonValue: Bool) {
		textStorage.enumerateAttribute(.paragraphStyle, in: range) { value, range, _ in
			guard let currentParagraphStyle = value as? NSParagraphStyle else {
				return
			}
			let paragraphStyle = NSMutableParagraphStyle() // Must create new instance or else 'ParagraphStyle' of entire attributed string will be affected
			paragraphStyle.setParagraphStyle(currentParagraphStyle) // Retain existing 'ParagraphStyle'
			paragraphStyle.lineHeightMultiple = 0
			paragraphStyle.setAbsoluteLineHeight(0)

			let newValue: CGFloat
			if isCommonValue {
				newValue = newLineSpaces[0]
			} else {
				if !newLineSpaces.isEmpty {
					newValue = newLineSpaces.removeFirst()
				} else {
					assertionFailure()
					return
				}
			}

			switch type {
			case .percent:
				if newValue == 0 {
					paragraphStyle.lineHeightMultiple = 1
				} else if newValue >= 100 {
					paragraphStyle.lineHeightMultiple = newValue / 100
				}
			case .absolute:
				paragraphStyle.setAbsoluteLineHeight(newValue)
			}
			textStorage.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
		}
	}

	func changeLineSpacing(
		to values: [CGFloat],
		ofType type: ParaStyle.Spacing.SpacingValue.SpacingValueType) {
		if let paragraphStyle = self.typingAttributes[.paragraphStyle] as? NSMutableParagraphStyle {
			let newParagraphStyle = NSMutableParagraphStyle()
			newParagraphStyle.setParagraphStyle(paragraphStyle)
			switch type {
			case .percent:
				newParagraphStyle.lineHeightMultiple = values[0] / 100
			case .absolute:
				newParagraphStyle.minimumLineHeight = values[0]
				newParagraphStyle.maximumLineHeight = values[0]
			}
			self.typingAttributes[.paragraphStyle] = newParagraphStyle
		}
	}

	func changeTextCase(
		to textCaseValue: Int,
		over ranges: [NSRange]? = nil,
		completionBlock: ((NSMutableAttributedString, NSRange) -> Void) -> Void) {
		let setTextCaseBlock = { (textStorage: NSMutableAttributedString, range: NSRange) in
			textStorage.enumerateAttributes(in: range) { attributes, chunkRange, _ in
				var portionAttributes = attributes
				portionAttributes[.zsTextCase] = textCaseValue
				textStorage.addAttributes(portionAttributes, range: chunkRange)
			}
		}
		self.typingAttributes[.zsTextCase] = textCaseValue
		completionBlock(setTextCaseBlock)
	}

	func changeUnderline(
		to type: LineType,
		over ranges: [NSRange]? = nil,
		completionBlock: (NSNumber) -> Void) {
		let underline = NSNumber(value: type.underlineStyle.rawValue)
		self.typingAttributes[.underlineStyle] = underline
		completionBlock(underline)
	}

	func changeStrikeThrough(
		to type: LineType,
		over ranges: [NSRange]? = nil,
		completionBlock: (NSNumber) -> Void) {
		let strike = NSNumber(value: type.underlineStyle.rawValue)
		self.typingAttributes[.strikethroughStyle] = strike
		completionBlock(strike)
	}
}

private extension LineType {
	var underlineStyle: NSUnderlineStyle {
		switch self {
		case .none:
			return .init(rawValue: 0)
		case .single:
			return .single
		}
	}
}
#endif
