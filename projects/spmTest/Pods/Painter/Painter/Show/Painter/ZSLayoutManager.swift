//
//  ZSLayoutManager.swift
//  Painter
//
//  Created by Sarath Kumar G on 26/03/20.
//  Copyright © 2020 Zoho Corporation Pvt. Ltd. All rights reserved.
//

#if !os(watchOS)
import Foundation
import Proto

#if os(macOS)
import AppKit.NSTextStorage
#else
import UIKit.NSTextStorage
#endif

public class ZSLayoutManager: NSLayoutManager {
	// Required for StartWith, not used in Show.
	public var shapeObjectFrame: CGRect = .zero
	public weak var pictureFillConfig: PainterConfig?

	public var isTextEditingMode = false
	public var firstLineOffset = CGFloat(0)

	private var shouldDrawBullets = false
	private var selectedParaIndex: Int = 0
	private var textBodyWithBullets: TextBody?
	private var contentTransform: CGAffineTransform = .identity

	override public func drawBackground(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
		guard
			let textStorage = self.textStorage
		else {
			super.drawBackground(forGlyphRange: glyphsToShow, at: origin)
			return
		}
		self.enumerateLineFragments(forGlyphRange: glyphsToShow) { _, _, _, lineRange, _ in
			let newRanges = self.rangesExcludingNewlines(textStorage: textStorage, from: lineRange)
			for currentRange in newRanges where textStorage.isValidSubRange(currentRange) {
				super.drawBackground(forGlyphRange: currentRange, at: origin)
			}
		}
	}

	override public func drawGlyphs(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
		super.drawGlyphs(forGlyphRange: glyphsToShow, at: origin)
		guard
			self.shouldDrawBullets,
			let textBody = self.textBodyWithBullets,
			let textStorage = self.textStorage
		else {
			return
		}
		var paraIndex = 0
		let scaleProps = textBody.props.scaleProps

		self.enumerateLineFragments(forGlyphRange: glyphsToShow) { _, usedRect, _, glyphRange, _ in
			var newLineRange = NSRange(location: 0, length: 0)
			var isFirstPara = false
			if glyphRange.location > 0 {
				newLineRange.location = glyphRange.location - 1
				newLineRange.length = 1
			} else {
				isFirstPara = true
			}
			var isNewLine = true
			var withAlpha = false
			if newLineRange.length > 0 {
				isNewLine = self.isNewlineCharacter(
					at: newLineRange,
					in: textStorage)
				var nextGlyphRange = newLineRange
				nextGlyphRange.location += 1
				withAlpha = self.isNewlineCharacter(
					at: nextGlyphRange,
					in: textStorage)
			}
			if isNewLine || isFirstPara {
				let attributes = textStorage.attributes(
					at: glyphRange.location,
					effectiveRange: nil)
				drawBullet(attributes: attributes, usedRect: usedRect, withAlpha: withAlpha)
				withAlpha = false
			}
		}

		// Render the bullet in the last line separately since its not rendering in enumerateLineFragments
		if let lastChar = textStorage.string.last, lastChar == "\n" {
			let attributedString = textBody.textAttributedString(bulletFree: true)
			let len = attributedString.length
			let lastParaUsedRect = self.extraLineFragmentUsedRect
			let attributesAtLastParagraph = attributedString.attributes(at: len - 1, effectiveRange: nil)
			drawBullet(attributes: attributesAtLastParagraph, usedRect: lastParaUsedRect, withAlpha: true)
		}

		func drawBullet(
			attributes: [NSAttributedString.Key: Any],
			usedRect: CGRect,
			withAlpha: Bool = false) {
			guard
				let paraStyle = attributes[.zsListParaStyle] as? ParaStyle
			else {
				paraIndex += 1
				return
			}
			var shouldScaleBullet = true
// Bullet with character value 8226 and 111 is drawn bigger hence the below code, these changes needn't be performed for IOS and hence the below os check
#if !os(macOS)
			if paraStyle.hasBullet, paraStyle.listStyle.bullet.type == .character, paraStyle.listStyle.bullet.character.ch == "8226" || paraStyle.listStyle.bullet.character.ch == "111" {
				shouldScaleBullet = false
			}
#endif
			let fontProps = self.getFontProps(forIndex: paraIndex, shouldScaleBullet: shouldScaleBullet)
			// Edge case while adding new line to end of a paragraph (Not likely to happen)
			if paraIndex >= textBody.paras.count {
				return
			}
			if !textBody.paras[paraIndex].hasBullet {
				paraIndex += 1
				return
			}
			let bulletIndex = textBody.getBulletIndex(forIndex: paraIndex)
			let bulletString = paraStyle.getBulletAttributedString(
				forIndex: bulletIndex,
				with: fontProps,
				and: scaleProps)

			var paraIndent = textBody.paras[paraIndex].style.indent
			// para Indent value is negative for hanging type and positive for first line type, hence the below conversion to always a positive number
			if paraIndent < 0 {
				paraIndent = -paraIndent
			}
			let scaledParaIndent = (CGFloat(paraIndent) * self.contentTransform.a)

			let bulletHeight = bulletString.size().height
			let computedHeight = (usedRect.height - bulletHeight) / 2
			let scaledBulletHeight = CGFloat(computedHeight) * self.contentTransform.a

			let xAxis = usedRect.origin.x - scaledParaIndent
			let yAxis = usedRect.origin.y + scaledBulletHeight
			let originPoint = CGPoint(x: xAxis, y: yAxis)

			if bulletString.length > 0 {
				if withAlpha {
					var oldAttr = bulletString.attributes(at: 0, effectiveRange: nil)
					if let oldColor = oldAttr[.foregroundColor] as? DeviceColor {
						if paraIndex == self.selectedParaIndex {
							oldAttr[.foregroundColor] = oldColor.withAlphaComponent(0.5)
						} else {
							oldAttr[.foregroundColor] = oldColor.withAlphaComponent(0)
						}
					}
					bulletString.setAttributes(oldAttr, range: bulletString.fullRange)
				}
				bulletString.draw(at: originPoint)
			}
			paraIndex += 1
		}
	}

#if os(macOS)
	private static var sharedManagerForMetrics = ZSLayoutManager()
#endif

	override public init() {
		super.init()
		self.delegate = self
		self.usesFontLeading = false
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

public extension ZSLayoutManager {
	class func defaultLineHeight(for theFont: DeviceFont) -> CGFloat {
#if os(macOS)
		return self.sharedManagerForMetrics.defaultLineHeight(for: theFont)
#else
		theFont.lineHeight
#endif
	}

	class func defaultBaselineOffset(for theFont: DeviceFont) -> CGFloat {
#if os(macOS)
		return self.sharedManagerForMetrics.defaultBaselineOffset(for: theFont)
#else
		return theFont.baselineOffset
#endif
	}

	func enableTextEditingMode(with delegate: NSLayoutManagerDelegate?) {
		self.isTextEditingMode = true
		self.delegate = delegate
	}

	func enableBulletDrawing(
		textBody: TextBody,
		affineTransform: CGAffineTransform) {
		self.shouldDrawBullets = true
		self.textBodyWithBullets = textBody
		self.contentTransform = affineTransform
	}

	func updateBulletInfo(textBody: TextBody, selectedParaIndex: Int) {
		self.textBodyWithBullets = textBody
		self.selectedParaIndex = selectedParaIndex
	}
}

// MARK: - NSLayoutManagerDelegate Conformance

extension ZSLayoutManager: NSLayoutManagerDelegate {
	public func layoutManager(
		_ layoutManager: NSLayoutManager,
		shouldSetLineFragmentRect lineFragmentRect: UnsafeMutablePointer<CGRect>,
		lineFragmentUsedRect: UnsafeMutablePointer<CGRect>,
		baselineOffset: UnsafeMutablePointer<CGFloat>,
		in textContainer: NSTextContainer,
		forGlyphRange glyphRange: NSRange) -> Bool {
		guard let textStorage = layoutManager.textStorage else {
			assertionFailure("TextStorage not available in \(#function) at \(#line)")
			return false
		}
		guard self.isTextEditingMode else {
			return true
		}
		if glyphRange.location == 0 {
			let charRange = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
			var maxDefaultLineHeight = textStorage.getMaxDefaultLineHeight(forRange: charRange)
			if let paragraphStyle = textStorage.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSMutableParagraphStyle {
				maxDefaultLineHeight *= max(1, paragraphStyle.lineHeightMultiple)
			}
			self.firstLineOffset = abs(maxDefaultLineHeight - lineFragmentUsedRect.pointee.height)

			let yOffset = self.firstLineOffset / 2
			lineFragmentRect.pointee.origin.y += yOffset
			lineFragmentUsedRect.pointee.origin.y += yOffset
		}
		baselineOffset.pointee += (self.firstLineOffset / 2)
		return true
	}
}

private extension ZSLayoutManager {
	func isNewlineCharacter(
		at glyphRange: NSRange,
		in textStorage: NSTextStorage) -> Bool {
		guard
			let subAttributedString = textStorage.getAttributedSubString(
				from: glyphRange
			)
		else {
			return false
		}

		return subAttributedString.string == "\n"
	}

	func getFontProps(forIndex paraIndex: Int, shouldScaleBullet: Bool) -> FontProps {
		var fontColor = DeviceColor.black
		var fontSize = PainterConfig.defaultFontSize * Float(self.contentTransform.a)

		guard let textBody = self.textBodyWithBullets else {
			return FontProps(size: fontSize, color: fontColor)
		}

		if textBody.paras.count > paraIndex,
		   let firstPortion = textBody.paras[paraIndex].portions.first {
			if firstPortion.hasProps, firstPortion.props.hasSize {
				if shouldScaleBullet {
					fontSize = Float(pointToPixel(CGFloat(firstPortion.props.size)))
				} else {
					fontSize = firstPortion.props.size
				}
				fontSize *= Float(self.contentTransform.a)
			}

			if !firstPortion.props.fill.solid.color.rgb.isEmpty {
				fontColor = firstPortion.props.fill.solid.color.platformColor
			}
		}
		return FontProps(size: fontSize, color: fontColor)
	}

	/// Computes ranges excludling newlines and zero width space characters
	/// - Parameters:
	///   - textStorage: NSTextStorage in which newlines and zero width space characters to be excludes
	///   - range: NSRange over which the exclusion should take place
	/// - Returns: Returns array of NSRange excluding newlines and zero width space characters
	func rangesExcludingNewlines(
		textStorage: NSTextStorage,
		from range: NSRange) -> [NSRange] {
		guard range.length != 0 else {
			return [range]
		}

		func appendEndRange() {
			if length != 0 {
				newRanges.append(NSRange(location: startIndex, length: length))
			}
		}

		var newRanges = [NSRange]()
		var length = 0
		let actualEndIndex = range.upperBound
		var currentIndex = range.lowerBound
		var startIndex = currentIndex
		while currentIndex < actualEndIndex {
			let subRange = NSRange(location: currentIndex, length: 1)
			guard
				let subString = textStorage.getAttributedSubString(from: subRange)?.string
			else {
				appendEndRange()
				return newRanges
			}
			if subString == "\n" || subString == "\u{200B}" {
				if length != 0 {
					newRanges.append(NSRange(location: startIndex, length: length))
				}
				length = 0
				startIndex = currentIndex + 1
			} else {
				length += 1
			}
			currentIndex += 1
		}
		appendEndRange()
		return newRanges
	}
}
#endif
