//
//  TextBody+Helper.swift
//  Painter
//
//  Created by Sarath Kumar G on 26/02/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

#if os(iOS) || os(tvOS)
import UIKit.NSTextStorage
#elseif os(watchOS)
import UIKit.NSAttributedString
#else
import AppKit.NSTextStorage
#endif

public extension TextBody {
	/// Returns a boolean indicating whether the given point lies within the TextBody's actual used rectangle.
	/// The test is performed using infinite height and not the height of the 'rect' parameter.
	/// You will have to check if the point lies outside the 'rect' beforehand
	/// if you are passing a 'rect' that clips TextBody's content based on height.
	///
	/// - Parameters:
	///   - point: The point on which the test has to be performed
	///   - forId: Unique ID of the 'Shape' containing the TextBody. It is used to get attributed string from cache.
	///   - rect: The rectangle in which the text will be laid out.
	///   - config: Painter Configuration
	/// - Returns: 'true' if the point lies within the rectangle used by the text else 'false'.
	func contains(
		point: CGPoint,
		forId shapeId: String,
		basedOn rect: CGRect,
		using config: PainterConfig?) -> Bool {
		let shapeBbox = getTextBbox(from: rect)
		let size = CGSize(
			width: self.getWidthBasedOnWrap(
				actual: shapeBbox.width,
				forId: shapeId,
				config: config),
			height: .greatestFiniteMagnitude)
		let textStorage = self.getTextStorageFromCache(
			forId: shapeId,
			size: size,
			using: config)
		guard
			let layoutManager = textStorage.layoutManagers.first,
			let textContainer = layoutManager.textContainers.first
		else {
			return false
		}
		let usedRect = layoutManager.usedRect(for: textContainer)
		let textOrigin = self.getTextOrigin(
			from: shapeBbox,
			and: usedRect.height)
		let pointRelativeToLayoutManger = point - textOrigin
		let glyphIndex = layoutManager.glyphIndex(
			for: pointRelativeToLayoutManger,
			in: textContainer,
			fractionOfDistanceThroughGlyph: nil)
		let lineRect = layoutManager.lineFragmentUsedRect(
			forGlyphAt: glyphIndex,
			effectiveRange: nil)
		return lineRect.contains(pointRelativeToLayoutManger)
	}

	func getContentSize(
		basedOn rect: CGRect,
		bulletFree: Bool = false,
		withInset: Bool = false,
		shouldScaleInset: Bool = true,
		using config: PainterConfig? = nil) -> CGSize {
		var size = TextBody.getContentSize(
			for: textAttributedString(using: config, bulletFree: bulletFree),
			basedOn: rect,
			shouldWrapText: props.wrap != .none)
		if withInset {
			let inset = props.getInset(withScale: shouldScaleInset)
			size.width += CGFloat(inset.left + inset.right)
			size.height += CGFloat(inset.top + inset.bottom)
		}
		return size
	}

	func getContentOrigin(
		basedOn rect: CGRect,
		bulletFree: Bool = false,
		withInset: Bool = false,
		shouldScaleInset: Bool = true,
		using config: PainterConfig? = nil) -> CGPoint {
		let usedRect = TextBody.self.getContentRect(
			for: textAttributedString(using: config, bulletFree: bulletFree),
			basedOn: rect,
			shouldWrapText: props.wrap != .none)
		let textOrigin = self.getTextOrigin(
			from: getTextBbox(from: rect),
			and: usedRect.height)
		return textOrigin
	}

	static func getTextViewFrame(from attributedString: NSAttributedString, basedOn frame: CGRect, with textBoxProps: TextBoxProps) -> CGRect {
		var textViewFrame = textBoxProps.getInsetRect(for: frame) // Apply insets

		// Get text origin based on vertical alignment
		let contentHeight = TextBody.getContentSize(for: attributedString, basedOn: textViewFrame, shouldWrapText: true).height
		textViewFrame.origin = textBoxProps.getTextOrigin(from: textViewFrame, and: contentHeight)
		textViewFrame.size.height = contentHeight
		return textViewFrame
	}

	func hasHAlignText() -> Bool {
		for para in paras where para.hasStyle && para.style.hasHalign {
			if para.style.halign == .left || para.style.halign == .right {
				return true
			}
		}
		return false
	}

	func getWidthBasedOnWrap(actual width: CGFloat, forId: String, config: PainterConfig?) -> CGFloat {
		// FIXME: - Handle text wrap
		if isSmartField, hasProps, props.hasWrap, props.wrap == .none {
			let infiniteRect = CGRect(
				x: 0,
				y: 0,
				width: CGFloat.greatestFiniteMagnitude,
				height: CGFloat.greatestFiniteMagnitude)
			let contentSize = TextBody.getContentSize(
				for: getAttributedStringFromCache(forId: forId, using: config),
				basedOn: infiniteRect,
				shouldWrapText: false)
			return max(width, contentSize.width)
		}
		return width
	}

	func resolveTextBody(painterConfig: PainterConfig, isPasteOp: Bool = false) -> TextBody {
		var newTextBody = self
		for index1 in 0..<newTextBody.paras.count {
			var para = newTextBody.paras[index1]
			for index in 0..<para.portions.count {
				var currentPortion = para.portions[index]
				if currentPortion.hasField, currentPortion.field.hasType, currentPortion.field.type == .datafield, currentPortion.field.hasDatafieldID {
					let name = currentPortion.field.datafieldID
					guard let dfId = painterConfig.getDataFieldIdForName(forDataFieldName: name) else {
						return newTextBody
					}
					currentPortion.field.datafieldID = dfId
					if isPasteOp {
						let newt = "$\u{2028}\(dfId)\u{2028}$(\(name))"
						currentPortion.t = newt
					}
				}
				para.portions[index] = currentPortion
			}
			newTextBody.paras[index1] = para
		}
		return newTextBody
	}
}

extension TextBody {
	func getTextBbox(from rect: CGRect) -> CGRect {
		if !isSmartField || (isSmartField && props.hasInset) {
			return props.getInsetRect(for: rect)
		} else {
			return rect
		}
	}

	func getSmartTextBbox(for rect: CGRect) -> CGRect {
		var textBbox = rect
		if isSmartField {
			textBbox = props.hasInset ? props.getInsetRect(for: rect) : rect
		}
		return textBbox
	}
}

private extension TextBody {
	var isSmartField: Bool {
		for para in paras {
			for portion in para.portions where portion.isSmartField {
				return true
			}
		}
		return false
	}
}

private extension Portion {
	var isSmartField: Bool {
		return self.hasField && self.field.hasType && self.field.type == .smart
	}
}

extension PortionProps {
	mutating func setFont(_ font: DeviceFont) {
#if os(macOS)
		guard let family = font.familyName else {
			assertionFailure("Font doesn't has a family name in \(#function) at \(#line)")
			return
		}
#else
		let family = font.familyName
#endif
		self.font.fontFamily.name = family
		self.fontweight = PainterFontHandler.shared.getFontWeight(
			forFont: font.fontName
		)
		self.italic = font.fontName.lowercased().matches("italic|oblique")
	}

	mutating func setColorProperties(_ attributes: [NSAttributedString.Key: Any]) {
		if let fontColor = attributes[.foregroundColor] as? DeviceColor, fontColor != .clear {
			self.fill.type = .solid
			self.fill.solid.color = fontColor.cgColor.color
		} else {
			self.fill.type = .solid
			self.fill.solid.color = CGColor.black.color // Default color: 'black'
		}

		if let backgroundColor = attributes[.zsHighlightBGColor] as? DeviceColor {
			self.highlight.type = .solid
			self.highlight.solid.color = backgroundColor.cgColor.color
		}
	}
}

extension ParaStyle {
	mutating func setLineSpacing(usingSystemParaStyle paraStyle: NSParagraphStyle) {
		var spacing = ParaStyle.Spacing.SpacingValue()
		if paraStyle.lineHeightMultiple != 0 {
			spacing.type = .percent
			spacing.percent = Float(paraStyle.lineHeightMultiple)
		} else if paraStyle.absoluteLineHeight != 0 {
			spacing.type = .absolute
			spacing.absolute = Float(paraStyle.absoluteLineHeight)
		}
		if !spacing.isEmpty {
			self.spacing.line = spacing
		}
	}
}

// MARK: - Text Default Properties

// TODO: Have added just placeholders. Yet to implement.
public extension TextBoxProps {
	static var `default`: TextBoxProps {
		return TextBoxProps()
	}
}

public extension Portion {
	static var `default`: Portion {
		return Portion()
	}
}

public extension ParaStyle {
	static var `default`: ParaStyle {
		return ParaStyle()
	}
}
