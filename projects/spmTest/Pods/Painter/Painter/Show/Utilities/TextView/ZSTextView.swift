//
//  ZSTextView.swift
//  Painter
//
//  Created by Sarath Kumar G on 11/08/21.
//  Copyright © 2021 Zoho Corporation Pvt. Ltd. All rights reserved.
//

#if !os(watchOS)
import GraphikosAppleAssets
#if os(macOS)
import AppKit.NSTextStorage
#else
import UIKit.NSTextStorage
#endif
import Proto

public class ZSTextView: ZSBaseTextView {
	override public init(
		frame: CGRect,
		delegate: ZSTextViewDelegate?,
		textContainer: NSTextContainer,
		config: PainterConfig? = nil) {
		super.init(
			frame: frame,
			delegate: delegate,
			textContainer: textContainer,
			config: config)
	}

#if os(macOS)
	override public func replaceCharacters(in range: NSRange, with string: String) {
		super.replaceCharacters(in: range, with: string)
		self.delegate?.textDidChange?(Notification(name: Notification.Name("textReplacement"), object: self))
	}

	override public func copy(_ sender: Any?) {
		(self.delegate as? ZSTextViewDelegate)?.copyText()
	}

	override public func paste(_ sender: Any?) {
		(self.delegate as? ZSTextViewDelegate)?.pasteText()
	}

	override public func drawInsertionPoint(in rect: NSRect, color: NSColor, turnedOn flag: Bool) {
		var adjustedRect = rect
		// Assuming bounds has the same region as the frame
		if rect.origin.x < 0 {
			adjustedRect.origin.x = 0
		} else if rect.origin.x + rect.width > self.bounds.width {
			adjustedRect.origin.x = self.bounds.width - rect.size.width
		}
		var cursorColor = self.typingAttributes[.foregroundColor] as? DeviceColor ?? color
		cursorColor = cursorColor.withAlphaComponent(color.alphaComponent)
		if self.frame.size.width == .zero {
			setFrameSize(adjustedRect.size)
		}
		super.drawInsertionPoint(in: adjustedRect, color: cursorColor, turnedOn: flag)
	}

	override public func keyDown(with event: NSEvent) {
		if event.keyCode == 125 {
			if (self.delegate as? ZSTextViewDelegate)?.downKeyPressed() ?? true {
				super.keyDown(with: event)
			}
		} else if event.keyCode == 126 {
			if (self.delegate as? ZSTextViewDelegate)?.upKeyPressed() ?? true {
				super.keyDown(with: event)
			}
		} else if event.keyCode == 36 {
			if (self.delegate as? ZSTextViewDelegate)?.enterKeyPressed() ?? true {
				super.keyDown(with: event)
			}
		} else {
			super.keyDown(with: event)
		}
	}

#endif

	override public func changeTypeface(to family: String, over ranges: [NSRange]? = nil) {
		super.changeTypeface(to: family, over: ranges)
		func setFontValue(in textStorage: NSMutableAttributedString, for range: NSRange) {
			textStorage.enumerateAttribute(.font, in: range) { value, fontRange, _ in
				guard let font = value as? DeviceFont else {
					assertionFailure("Can't cast value to type DeviceFont")
					return
				}
				if let newFont = super.getNewFont(for: font, withFamily: family) {
					textStorage.addAttribute(.font, value: newFont, range: fontRange)
				} else {
					assertionFailure("One font with given family name will at least be available.")
				}
			}
		}
		guard ranges != nil || !self.selectionIsForTypingAttributes else {
			return
		}
		let rangesToModify = ranges ?? self.textContent.selectedRanges
		self.updateTextStorage(inRanges: rangesToModify) { textStorage, ranges in
			for selectedRange in ranges {
				setFontValue(in: textStorage, for: selectedRange)
			}
			self.updateMaxLineHeight(
				in: textStorage,
				over: self.getParagraphRangesOfSelection()[0])
		}
		(self.delegate as? ZSTextViewDelegate)?.resize(self)
	}

#if os(iOS)
	override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		if #available(iOS 16, *) {
			return super.canPerformAction(action, withSender: sender)
		}
		if let menuItems = (sender as? UIMenuController)?.menuItems {
			return menuItems.contains { $0.action == action }
		}
		return false
	}

	override public func cut(_ sender: Any?) {
		if #available(iOS 16, *) {
			(self.delegate as? ZSTextViewDelegate)?.cutText()
		}
	}

	override public func copy(_ sender: Any?) {
		if #available(iOS 16, *) {
			(self.delegate as? ZSTextViewDelegate)?.copyText()
		}
	}

	override public func paste(_ sender: Any?) {
		if #available(iOS 16, *) {
			(self.delegate as? ZSTextViewDelegate)?.pasteText()
		}
	}

	override public func endFloatingCursor() {
		super.endFloatingCursor()
		(self.delegate as? ZSTextViewDelegate)?.endFloatingCursor()
	}

	override public func beginFloatingCursor(at point: CGPoint) {
		super.beginFloatingCursor(at: point)
		(self.delegate as? ZSTextViewDelegate)?.beginFloatingCursor()
	}
#endif
}

#if !os(tvOS)
@available(iOS, deprecated: 16, message: "Use UITextViewDelegate's 'textView(_:editMenuForTextIn:suggestedActions:)' to handle text menu items")
@objc
public extension ZSTextView {
	func handleFormatMenuItemAction(sender: PlatformMenuItem) {
#if os(iOS)
		(self.delegate as? ZSTextViewDelegate)?.openTextFormatMenu()
#endif
	}

	func handleSelectMenuItemAction(sender: PlatformMenuItem) {
#if os(iOS)
		super.select(sender)
#endif
	}

	func handleInsertSymbolMenuItemAction(sender: PlatformMenuItem) {
#if os(iOS)
		(self.delegate as? ZSTextViewDelegate)?.openInsertSymbolContainer()
#endif
	}

	func handleSelectAllMenuItemAction(sender: PlatformMenuItem) {
		super.selectAll(sender)
	}

	func handleCutMenuItemAction(sender: PlatformMenuItem) {
		(self.delegate as? ZSTextViewDelegate)?.cutText()
	}

	func handleCopyMenuItemAction(sender: PlatformMenuItem) {
		(self.delegate as? ZSTextViewDelegate)?.copyText()
	}

	func handlePasteMenuItemAction(sender: PlatformMenuItem) {
		(self.delegate as? ZSTextViewDelegate)?.pasteText()
	}

	func handleDeleteMenuItemAction(sender: PlatformMenuItem) {
		(self.delegate as? ZSTextViewDelegate)?.deleteText()
	}
}
#endif

public extension ZSTextView {
	var nsTextStorage: NSTextStorage {
#if os(macOS)
		guard let textStorage = self.textStorage else {
			return NSTextStorage()
		}
		return textStorage
#else
		return self.textStorage
#endif
	}

	/*
	 * In Show, font size gets incremented relatively.
	 * For e.g., Let "Hello world" be the text content
	 * "Hello " has a font size of 16px and "world" has a font size of 20 px
	 * Let's assume that the font size of the entire text gets incremented by 1
	 * Now, "Hello " will be of size 17px and "world" will be of size 21 px
	 */

	func increaseFontSize(by stepValue: Double, over ranges: [NSRange]? = nil) {
		self.updateFontSizeInTypingAttributes(by: stepValue)
		if ranges != nil || !self.selectionIsForTypingAttributes {
			let rangesToModify = ranges ?? self.textContent.selectedRanges
			self.updateTextStorage(inRanges: rangesToModify) { textStorage, ranges in
				for range in ranges {
					self.updateFontSize(in: textStorage, over: range, by: stepValue)
					self.updateMaxLineHeight(in: textStorage, over: range)
				}
			}
		}
		(self.delegate as? ZSTextViewDelegate)?.resize(self)
	}

	func changeFontWeight(
		over ranges: [NSRange]? = nil,
		with fetchNewStyleIdBlock: @escaping ((String) -> String)) {
		if let currentFont = self.typingAttributes[.font] as? DeviceFont {
			let styleId = FontHandler.shared.getStyleId(forFont: currentFont.fontName)
			let newStyleId = fetchNewStyleIdBlock(styleId)
			if let newFontId = (self.delegate as? ZSTextViewDelegate)?
				.getFontId(forFamily: currentFont.deviceFamilyName, withStyleId: newStyleId) {
				let newFont = DeviceFont(name: newFontId, size: currentFont.pointSize) as Any
				self.typingAttributes[.font] = newFont
			} else {
				assertionFailure("Unable to get font ID in \(#function)")
			}
		}
		if ranges != nil || !self.selectionIsForTypingAttributes {
			let rangesToModify = ranges ?? self.textContent.selectedRanges
			self.updateTextStorage(inRanges: rangesToModify) { textStorage, ranges in
				for range in ranges {
					textStorage.enumerateAttribute(.font, in: range) { value, fontRange, _ in
						guard let font = value as? DeviceFont else {
							return
						}
						let styleId = FontHandler.shared.getStyleId(
							forFont: font.fontName
						)
						let newStyleId = fetchNewStyleIdBlock(styleId)
						if let fontId = (self.delegate as? ZSTextViewDelegate)?
							.getFontId(forFamily: font.deviceFamilyName, withStyleId: newStyleId) {
							let newFont = DeviceFont(name: fontId, size: font.pointSize) as Any
							textStorage.addAttribute(.font, value: newFont, range: fontRange)
						}
					}
				}
			}
			(self.delegate as? ZSTextViewDelegate)?.resize(self)
		}
	}

	func changeBaseline(to baselineValue: Float, over ranges: [NSRange]? = nil) {
		self.updateBaselineInTypingAttributes(to: baselineValue)
		if ranges != nil || !self.selectionIsForTypingAttributes {
			let rangesToModify = ranges ?? self.textContent.selectedRanges
			self.updateTextStorage(inRanges: rangesToModify) { textStorage, ranges in
				for range in ranges {
					self.updateBaseline(in: textStorage, over: range, to: baselineValue)
					self.updateMaxLineHeight(in: textStorage, over: range)
				}
			}
			(self.delegate as? ZSTextViewDelegate)?.resize(self)
		}
	}

	func changeHeadIndent(
		to value: CGFloat,
		over ranges: [NSRange]? = nil,
		isLastPara: Bool = false) {
		func updatedParaStyle(for paraStyle: NSParagraphStyle) -> NSMutableParagraphStyle {
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.setParagraphStyle(paraStyle)
			paragraphStyle.headIndent = value
			return paragraphStyle
		}

		if let paraStyle = self.typingAttributes[.paragraphStyle] as? NSParagraphStyle {
			self.typingAttributes[.paragraphStyle] = updatedParaStyle(for: paraStyle)
		}

		let paraRanges = ranges ?? self.getParagraphRangesOfSelection()
		self.updateTextStorage(inRanges: paraRanges) { textStorage, ranges in
			for range in ranges {
				let newRange = !isLastPara ? self.getUpdatedRange(for: range) : range
				textStorage.enumerateAttribute(.paragraphStyle, in: newRange) { attribute, chunkRange, _ in
					guard let paraStyle = attribute as? NSParagraphStyle else {
						return
					}
					textStorage.addAttribute(
						.paragraphStyle,
						value: updatedParaStyle(for: paraStyle),
						range: chunkRange)
				}
			}
		}
	}

	func changeFirstLineHeadIndent(
		to value: CGFloat,
		over ranges: [NSRange]? = nil,
		isLastPara: Bool = false) {
		func updatedParaStyle(for paraStyle: NSParagraphStyle) -> NSMutableParagraphStyle {
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.setParagraphStyle(paraStyle)
			paragraphStyle.firstLineHeadIndent = value
			return paragraphStyle
		}

		if let paraStyle = self.typingAttributes[.paragraphStyle] as? NSParagraphStyle {
			self.typingAttributes[.paragraphStyle] = updatedParaStyle(for: paraStyle)
		}

		let paraRanges = ranges ?? self.getParagraphRangesOfSelection()
		self.updateTextStorage(inRanges: paraRanges) { textStorage, ranges in
			for range in ranges {
				let newRange = !isLastPara ? self.getUpdatedRange(for: range) : range
				textStorage.enumerateAttribute(.paragraphStyle, in: newRange) { attribute, chunkRange, _ in
					guard let paraStyle = attribute as? NSParagraphStyle else {
						return
					}
					textStorage.addAttribute(
						.paragraphStyle,
						value: updatedParaStyle(for: paraStyle),
						range: chunkRange)
				}
			}
		}
	}

	func changeParagraphSpacing(
		from paraStyle: ParaStyle,
		with scaleProps: ScaleProps?,
		isBefore: Bool,
		over ranges: [NSRange]? = nil) {
		let scaleProps = scaleProps ?? ScaleProps()

		var spacingValue = paraStyle.getParaSpacing(from: paraStyle.spacing.after, with: scaleProps)
		if isBefore {
			spacingValue = paraStyle.getParaSpacing(from: paraStyle.spacing.before, with: scaleProps)
		}

		let rangesToModify = ranges ?? self.getParagraphRangesOfSelection()
		self.updateTextStorage(inRanges: rangesToModify) { textStorage, paraRanges in
			for range in paraRanges {
				textStorage.enumerateAttribute(.paragraphStyle, in: range) { value, valueRange, _ in
					if let currentParagraphStyle = value as? NSParagraphStyle {
						let paragraphStyle = NSMutableParagraphStyle() // Must create new instance or else 'ParagraphStyle' of entire attributed string will be affected
						paragraphStyle.setParagraphStyle(currentParagraphStyle) // Retain existing 'ParagraphStyle'

						if isBefore { // Before Paragraph Spacing
							paragraphStyle.paragraphSpacingBefore = spacingValue
						} else { // After Paragraph Spacing
							paragraphStyle.paragraphSpacing = spacingValue
						}
						textStorage.addAttribute(.paragraphStyle, value: paragraphStyle, range: valueRange)
					}
				}
			}
		}
		(self.delegate as? ZSTextViewDelegate)?.resize(self)

		// For typing Attributes
		if let paragraphStyle = self.typingAttributes[.paragraphStyle] as? NSMutableParagraphStyle {
			let newParagraphStyle = NSMutableParagraphStyle()
			newParagraphStyle.setParagraphStyle(paragraphStyle)
			if isBefore { // Before Paragraph Spacing
				newParagraphStyle.paragraphSpacingBefore = spacingValue
			} else { // After Paragraph Spacing
				newParagraphStyle.paragraphSpacing = spacingValue
			}
			self.typingAttributes[.paragraphStyle] = newParagraphStyle
		}
	}

	func updateParaStyle(
		to paraStyle: ParaStyle,
		over ranges: [NSRange]? = nil,
		isLastPara: Bool = false) {
		self.typingAttributes[.zsListParaStyle] = paraStyle
		guard ranges != nil || !self.selectionIsForTypingAttributes else {
			return
		}
		var rangesToModify = ranges ?? self.getParagraphRangesOfSelection()
		for (index, oldRange) in rangesToModify.enumerated() where oldRange.length == 0 {
			if oldRange.location != self.nsTextStorage.length {
				rangesToModify[index] = NSRange(location: oldRange.location, length: 1)
			} else if oldRange.location > 0, isLastPara {
				rangesToModify[index] = NSRange(location: oldRange.location - 1, length: 1)
			}
		}

		self.updateTextStorage(inRanges: rangesToModify) { textStorage, selectedRanges in
			for selectedRange in selectedRanges {
				textStorage.enumerateAttributes(in: selectedRange) { _, range, _ in
					textStorage.addAttribute(.zsListParaStyle, value: paraStyle, range: range)
				}
			}
		}

		// Resize has to be called explicitly for text case changes.
		(self.delegate as? ZSTextViewDelegate)?.resize(self)
	}

	func removeAttributes(withKeys keys: [NSAttributedString.Key], over ranges: [NSRange]?) {
		let rangesToModify = ranges ?? self.textContent.selectedRanges
		self.updateTextStorage(inRanges: rangesToModify) { attributedString, chunkRanges in
			for key in keys {
				for chunkRange in chunkRanges {
					attributedString.removeAttribute(key, range: chunkRange)
				}
			}
		}
	}

	func updateScale(from oldScaleProps: ScaleProps, to newScaleProps: ScaleProps) {
// TODO: apply fontscale and linespacescale to entire range of textstorage
#if os(macOS)
		guard let fullRange = self.textStorage?.fullRange else {
			return
		}
#else
		let fullRange = self.textStorage.fullRange
#endif

		self.updateTextStorage(inRanges: [fullRange]) { stringToUpdate, ranges in
			var scale: Float = 1.0
			if oldScaleProps.lineSpaceScale > 0 {
				scale *= 1.0 / oldScaleProps.lineSpaceScale
				scale *= newScaleProps.lineSpaceScale
			}
			if oldScaleProps.fontScale > 0 {
				scale *= 1.0 / oldScaleProps.fontScale
				scale *= newScaleProps.fontScale
			}
			var oldScale = oldScaleProps.lineSpaceScale > 0 ? oldScaleProps.lineSpaceScale : 1.0
			if oldScaleProps.fontScale > 0 {
				oldScale *= oldScaleProps.fontScale
			}
			var newScale = newScaleProps.lineSpaceScale > 0 ? newScaleProps.lineSpaceScale : 1.0
			if newScaleProps.fontScale > 0 {
				newScale *= newScaleProps.fontScale
			}
			for range in ranges {
				stringToUpdate.enumerateAttributes(in: range) { attributes, chunkRange, _ in
					if let currentFont = attributes[.font] as? DeviceFont {
						var modifiedFontSize = currentFont.pointSize * CGFloat(oldScaleProps.fontScale)
						modifiedFontSize *= CGFloat(newScaleProps.fontScale)
						let modifiedFont = DeviceFont(
							name: currentFont.fontName,
							size: modifiedFontSize)
						stringToUpdate.addAttribute(.font, value: modifiedFont as Any, range: chunkRange)
					}

					if let paragraphStyle = attributes[.paragraphStyle] as? NSParagraphStyle {
						let updatedParagraphStyle = NSMutableParagraphStyle()
						updatedParagraphStyle.setParagraphStyle(paragraphStyle)
						//							updatedParagraphStyle.minimumLineHeight *= CGFloat(scale)
						//							updatedParagraphStyle.maximumLineHeight *= CGFloat(scale)
						//							updatedParagraphStyle.lineHeightMultiple *= CGFloat(scale)
						updatedParagraphStyle.minimumLineHeight /= CGFloat(oldScale)
						updatedParagraphStyle.maximumLineHeight /= CGFloat(oldScale)
						updatedParagraphStyle.lineHeightMultiple /= CGFloat(oldScale)

						updatedParagraphStyle.minimumLineHeight *= CGFloat(newScale)
						updatedParagraphStyle.maximumLineHeight *= CGFloat(newScale)
						updatedParagraphStyle.lineHeightMultiple *= CGFloat(newScale)
						stringToUpdate.addAttribute(.paragraphStyle, value: updatedParagraphStyle, range: chunkRange)
					}
				}
			}
		}
	}

	func changeLineSpacing(
		to values: [CGFloat],
		ofType type: ParaStyle.Spacing.SpacingValue.SpacingValueType,
		over ranges: [NSRange]? = nil) {
		guard !values.isEmpty else {
			assertionFailure("LineSpace values shouldn't be empty in \(#function) at \(#line)")
			return
		}
		var newLineSpaces = values
		super.changeLineSpacing(to: newLineSpaces, ofType: type)
		let paraRanges = ranges ?? self.getParagraphRangesOfSelection()
		self.updateTextStorage(inRanges: paraRanges) { textStorage, ranges in
			for selectedRange in ranges {
				super.updateParaStyle(
					in: textStorage,
					over: selectedRange,
					with: &newLineSpaces,
					ofType: type,
					isCommonValue: true)
			}
		}
		(self.delegate as? ZSTextViewDelegate)?.resize(self)
	}

	func changeTextCase(to textCaseValue: Int, over ranges: [NSRange]? = nil) {
		super.changeTextCase(to: textCaseValue, over: ranges) { setTextCase in
			guard ranges != nil || !self.selectionIsForTypingAttributes else {
				return
			}
			let rangesToModify = ranges ?? self.textContent.selectedRanges
			self.updateTextStorage(inRanges: rangesToModify) { textStorage, ranges in
				for selectedRange in ranges {
					setTextCase(textStorage, selectedRange)
				}
			}
			(self.delegate as? ZSTextViewDelegate)?.resize(self)
		}
	}

	func changeUnderline(to type: LineType, over ranges: [NSRange]? = nil) {
		super.changeUnderline(to: type, over: ranges) { underline in
			guard ranges != nil || !self.selectionIsForTypingAttributes else {
				return
			}
			let rangesToModify = ranges ?? self.textContent.selectedRanges
			self.updateTextStorage(inRanges: rangesToModify) { textStorage, ranges in
				for range in ranges {
					textStorage.addAttribute(.underlineStyle, value: underline, range: range)
				}
			}
		}
	}

	func changeStrikeThrough(to type: LineType, over ranges: [NSRange]? = nil) {
		super.changeStrikeThrough(to: type, over: ranges) { strike in
			guard ranges != nil || !self.selectionIsForTypingAttributes else {
				return
			}
			let rangesToModify = ranges ?? self.textContent.selectedRanges
			self.updateTextStorage(inRanges: rangesToModify) { textStorage, ranges in
				for range in ranges {
					textStorage.addAttribute(.strikethroughStyle, value: strike, range: range)
				}
			}
		}
	}
}

private extension ZSTextView {
	func updateFontSize(
		in textStorage: NSMutableAttributedString,
		over range: NSRange,
		by stepValue: Double) {
		textStorage.enumerateAttributes(in: range) { attributes, range, _ in
			let newFontAttributes = self.getNewFontSizeIncrementing(
				by: stepValue,
				from: attributes)
			if let newFont = newFontAttributes[.font] {
				textStorage.addAttribute(
					.font,
					value: newFont,
					range: range)
			}
			if let actualFontSize = newFontAttributes[.zsFontSizeWithoutBaseline] {
				textStorage.addAttribute(
					.zsFontSizeWithoutBaseline,
					value: actualFontSize,
					range: range)
			}
		}
	}

	func updateBaseline(
		in textStorage: NSMutableAttributedString,
		over range: NSRange,
		to baselineValue: Float) {
		textStorage.enumerateAttributes(in: range) { attributes, range, _ in
			let baselineAttributes = self.getNewFontBaselineAttributes(
				forBaseline: baselineValue,
				from: attributes)
			if let newFont = baselineAttributes[.font] {
				textStorage.addAttribute(.font, value: newFont, range: range)
			}

			if let newBaselineOffset = baselineAttributes[.baselineOffset] {
				textStorage.addAttribute(
					.baselineOffset,
					value: newBaselineOffset,
					range: range)
			} else {
				textStorage.removeAttribute(.baselineOffset, range: range)
			}

			if let actualFontSize = baselineAttributes[.zsFontSizeWithoutBaseline] {
				textStorage.addAttribute(
					.zsFontSizeWithoutBaseline,
					value: actualFontSize,
					range: range)
			} else {
				textStorage.removeAttribute(.zsFontSizeWithoutBaseline, range: range)
			}
		}
	}

	func updateBaselineInTypingAttributes(to baselineValue: Float) {
		let baselineAttributes = self.getNewFontBaselineAttributes(
			forBaseline: baselineValue,
			from: self.typingAttributes)
		if let newFont = baselineAttributes[.font] {
			self.typingAttributes[.font] = newFont
		}
		self.typingAttributes[.baselineOffset] = baselineAttributes[.baselineOffset]
		self.typingAttributes[.zsFontSizeWithoutBaseline] = baselineAttributes[.zsFontSizeWithoutBaseline]
		self.updateMaxLineHeightInTypingAttributes()
	}

	func getNewFontBaselineAttributes(
		forBaseline baselineValue: Float,
		from attributes: [NSAttributedString.Key: Any]) -> [NSAttributedString.Key: Any] {
		var newFont: DeviceFont?
		var newBaselineOffset: CGFloat?
		var fontSizeWithoutBaseline: CGFloat?

		if let font = attributes[.font] as? DeviceFont {
			var newFontSize = font.pointSize
			if let prevBaseline = attributes[.baselineOffset] as? CGFloat,
			   let actualFontSize = attributes[.zsFontSizeWithoutBaseline] as? CGFloat {
				if baselineValue == 0 {
					newBaselineOffset = nil
					newFontSize = actualFontSize
				} else {
					if prevBaseline == 0 {
						newFontSize *= 0.63
					}
					fontSizeWithoutBaseline = actualFontSize
					newBaselineOffset = newFontSize * CGFloat(baselineValue)
				}
			} else if baselineValue != 0 {
				fontSizeWithoutBaseline = newFontSize
				newFontSize *= 0.63
				newBaselineOffset = newFontSize * CGFloat(baselineValue)
			}
			newFont = DeviceFont(name: font.fontName, size: newFontSize)
		}
		var newBaselineAttributes: [NSAttributedString.Key: Any] = [:]
		if let newFont = newFont {
			newBaselineAttributes[.font] = newFont as Any
		}
		if let newBaselineOffset = newBaselineOffset {
			newBaselineAttributes[.baselineOffset] = newBaselineOffset
		}
		if let actualFontSize = fontSizeWithoutBaseline {
			newBaselineAttributes[.zsFontSizeWithoutBaseline] = actualFontSize
		}
		return newBaselineAttributes
	}

	func updateMaxLineHeight(in textStorage: NSMutableAttributedString, over range: NSRange) {
		let paraRange = (textStorage.string as NSString).paragraphRange(for: range)
		guard
			let maxFontSize = self.getMaxFontSize(in: textStorage, for: range)
		else {
			return
		}

		textStorage.enumerateAttribute(.paragraphStyle, in: paraRange) { value, range, _ in
			guard let paragraphStyle = value as? NSMutableParagraphStyle else {
				return
			}
			let newParagraphStyle = paragraphStyle.getModifiedParagraphStyle(
				fontSize: maxFontSize
			)
			textStorage.addAttribute(
				.paragraphStyle,
				value: newParagraphStyle,
				range: range)
		}
	}

	func getNewFontSizeIncrementing(
		by stepValue: Double,
		from attributes: [NSAttributedString.Key: Any]) -> [NSAttributedString.Key: Any] {
		guard let currentFont = attributes[.font] as? DeviceFont else {
			return [:]
		}
		var newFontSize = currentFont.pointSize + CGFloat(stepValue)
		var actualFontSize = newFontSize
		if let baselineOffset = attributes[.baselineOffset] as? CGFloat,
		   baselineOffset != 0,
		   let fontSize = attributes[.zsFontSizeWithoutBaseline] as? CGFloat {
			actualFontSize = fontSize + CGFloat(stepValue) // Increment actual font size
			newFontSize = actualFontSize * 0.63
		}
		let newFont = DeviceFont(name: currentFont.fontName, size: newFontSize) as Any
		return [.font: newFont, .zsFontSizeWithoutBaseline: actualFontSize]
	}

	func updateFontSizeInTypingAttributes(by stepValue: Double) {
		let newFontAttributes = self.getNewFontSizeIncrementing(
			by: stepValue,
			from: self.typingAttributes)
		if let newFont = newFontAttributes[.font] {
			self.typingAttributes[.font] = newFont
		}
		if let actualFontSize = newFontAttributes[.zsFontSizeWithoutBaseline] {
			self.typingAttributes[.zsFontSizeWithoutBaseline] = actualFontSize
		}
		self.updateMaxLineHeightInTypingAttributes()

		let paraRanges = self.getParagraphRangesOfSelection()
		self.updateTextStorage(inRanges: paraRanges) { textStorage, ranges in
			for range in ranges {
				self.updateMaxLineHeight(in: textStorage, over: range)
			}
		}
	}

	func updateMaxLineHeightInTypingAttributes() {
		let paraRanges = self.getParagraphRangesOfSelection()
		let attributedString: NSMutableAttributedString? = self.textStorage
		if
			let range = paraRanges.first,
			let attributedString = attributedString,
			let maxFontSize = self.getMaxFontSize(in: attributedString, for: range) {
			let typingAttributesParaStyle = self.typingAttributes[.paragraphStyle]
			if let paragraphStyle = typingAttributesParaStyle as? NSParagraphStyle {
				self.typingAttributes[.paragraphStyle] = paragraphStyle.getModifiedParagraphStyle(fontSize: maxFontSize)
			}
		}
	}

	func getMaxFontSize(
		in textStorage: NSMutableAttributedString,
		for range: NSRange) -> CGFloat? {
		let paraRange = (textStorage.string as NSString).paragraphRange(for: range)
		guard
			let paraSubString = textStorage.getAttributedSubString(from: paraRange)
		else {
			return nil
		}
		var maxFontSize = paraSubString.maxFontSize
		if let typingAttributesFontSize = self.typingAttributes[.zsFontSizeWithoutBaseline] as? CGFloat {
			maxFontSize = max(maxFontSize, typingAttributesFontSize)
		}
		return maxFontSize
	}

	func getUpdatedRange(for range: NSRange) -> NSRange {
		guard
			range.length == 0,
			range.location != self.nsTextStorage.length
		else {
			return range
		}
		return NSRange(location: range.location, length: 1)
	}
}
#endif
