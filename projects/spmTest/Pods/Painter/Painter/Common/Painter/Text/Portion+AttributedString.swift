//
//  Portion+AttributedString.swift
//  Painter
//
//  Created by Sarath Kumar G on 02/12/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit.NSAttributedString
#else
import AppKit.NSAttributedString
#endif
typealias TextAttributes = [NSAttributedString.Key: Any]
import Proto

public extension Portion {
	var fontProps: FontProps {
		var fontColor = DeviceColor.black
		if !self.props.fill.solid.color.rgb.isEmpty {
			fontColor = self.props.fill.solid.color.platformColor
		}

		var fontSize = PainterConfig.defaultFontSize
		if self.hasProps, self.props.hasSize {
			fontSize = Float(pointToPixel(CGFloat(self.props.size)))
		}

		return FontProps(size: fontSize, color: fontColor)
	}

	/// Apply styles to a 'Portion' of a 'Paragraph'
	func rawString(using config: PainterConfig?, casedString: Bool, dataField: String) -> String {
		guard let cString = t.cString(using: .utf8) else {
			return self.zeroWidthSpaceCharacter
		}
		var portionString = String(cString: cString)

		if portionString.isEmpty {
			portionString = self.zeroWidthSpaceCharacter // Empty String
		}
		if !dataField.isEmpty {
			portionString = dataField
		}

		if props.hasCap, casedString {
			props.convertCase(of: &portionString) // Text case conversion
		}

		if hasType {
			if let portionContent = getPortionTypeContent(using: config) { // Textfield type
				portionString = portionContent
			}
		}
		return portionString
	}
}

private extension Portion {
	/// Space Character as 'String' Object
	var zeroWidthSpaceCharacter: String {
		return "\u{200B}"
	}

	/// Get contents of the 'Portion' according to 'TextField' type
	func getPortionTypeContent(using config: PainterConfig? = nil) -> String? {
		if self.type == .linebreak {
			// TODO: line break should not create a new paragraph
			//                *isLineBreak = YES; // needs clarification
			return String(format: "%@%@", self.zeroWidthSpaceCharacter, "\u{2028}") // \u{2028} - Line Separator
		} else if self.type == .field {
			if self.field.type == .datetime {
				return self.field.datetime.formattedDate
			}
			// Field type 'slidenum' has been handled from app
		}
		return nil
	}
}

public extension PortionProps {
	func getAttributes(
		withFontScale fontScale: Float,
		withTextStyleProps textStyleProps: TextBoxProps.TextStyleProps.TextProperties?,
		using config: PainterConfig?,
		casedString: Bool,
		shapeId: String? = nil,
		dataFieldBgColor: DeviceColor? = nil) -> [NSAttributedString.Key: Any] {
		var attributes = [NSAttributedString.Key: Any]()
		if self.hasFill, self.fill.hasType { // Font Color
			switch self.fill.type {
			case .solid:
				attributes[.foregroundColor] = self.fill.solid.color.platformColor
			case .grp:
				// use fill from TextStyle for type ".grp" (Text Effects)
				if let textStyleProps = textStyleProps {
					if textStyleProps.hasStroke,
					   textStyleProps.stroke.hasFill,
					   let fontColor = textStyleProps.stroke.fill.deviceColor {
						attributes[.foregroundColor] = fontColor
					} else if textStyleProps.hasFill,
					          let fontColor = textStyleProps.fill.deviceColor {
						attributes[.foregroundColor] = fontColor
					} else {
						// If both stroke and fill doesn't exist, set 'black' as default font color
						attributes[.foregroundColor] = DeviceColor.black
					}
				}
			default:
				break
			}
		}
		if self.hasStrike, self.strike == .single { // Strikethrough
			attributes[.strikethroughStyle] = NSNumber(value: NSUnderlineStyle.single.rawValue)
		}
		if self.hasUnderline, self.underline == .single { // Underline
			attributes[.underlineStyle] = NSNumber(value: NSUnderlineStyle.single.rawValue)
		}
		if self.hasSpace { // Letter Spacing
			attributes[.kern] = NSNumber(value: self.space)
		}
		if self.hasCap, !casedString { // Text case
			attributes[.zsTextCase] = self.cap.rawValue
		}
		if self.hasTextLayerProps {
			attributes[.zsTextLayerProps] = self.textLayerProps

			if let singleSolidFill = self.textLayerProps.singleSolidFill {
				attributes[.foregroundColor] = singleSolidFill.solid.color.platformColor
			}
		}
		if self.hasStyleRef {
			attributes[.zsCharacterStyleRef] = self.styleRef
		}

		if self.hasClick, self.click.type != .none, self.click.hasLinkStyle { // Hyperlink
			attributes[.zsHyperLinkData] = self.click
			if self.click.linkStyle.hasFill,
			   self.click.linkStyle.fill.type == .solid,
			   self.click.linkStyle.fill.solid.hasColor {
				let hyperlinkColor = self.click.linkStyle.fill.solid.color.platformColor
				attributes[.foregroundColor] = hyperlinkColor
				attributes[.zsHyperLinkColor] = self.fill.solid.color.platformColor
			}

			if self.click.linkStyle.hasUnderline, self.click.linkStyle.underline == .single {
				attributes[.underlineStyle] = NSNumber(value: NSUnderlineStyle.single.rawValue)
				if self.hasUnderline, self.underline == .single {
					attributes[.zsHyperLinkUnderLine] = NSNumber(value: NSUnderlineStyle.single.rawValue)
				}
			}
		}

		attributes[.zsDataFieldsBGColor] = dataFieldBgColor

		if self.hasHighlight, self.highlight.type != .none {
			var highlighColor = self.highlight.solid.color.platformColor
			if let alpha = config?.getHighlightColorAlpha(shapeId: shapeId) {
				highlighColor = highlighColor.withAlphaComponent(alpha)
			}
			attributes[.zsHighlightBGColor] = highlighColor
		}

		attributes.updateBackgroundColor()

		self.addFontBaselineAttributes(
			to: &attributes,
			withFontScale: fontScale,
			using: config) // Font and Baseline
		return attributes
	}
}

private extension PortionProps {
	/// Convert case for given portion string
	func convertCase(of portionString: inout String) {
		switch cap {
		case .allcaps:
			portionString = portionString.uppercased()
		case .smallcaps:
			portionString = portionString.lowercased()
		case .capitalize:
			// FIXME: What if capitalize starts in between a word.
			// A letter that is not first letter in the word will captialized. This shouldn't happen.
			portionString = portionString.capitalized
		case .none:
			break
		}
	}

	// Add attributes for 'Subscript' or 'Superscript' and Font
	func addFontBaselineAttributes(
		to attributes: inout [NSAttributedString.Key: Any],
		withFontScale fontScale: Float,
		using config: PainterConfig?) {
		var fontSize = CGFloat(((hasSize && size > 0) ? PainterConfig.actualFontSize(forSize: size) : PainterConfig.defaultFontSize) * fontScale)

		if hasBaseline, baseline != 0.0 {
			// 'kCTSuperscriptAttributeName' is not working in iOS 10.3 and later which is a BUG.
			// Instead 'NSBaselineOffsetAttributeName' can be used. Refer this https://forums.developer.apple.com/thread/72892
			attributes[.baselineOffset] = CGFloat(baseline * size * fontScale)
			attributes[.zsFontSizeWithoutBaseline] = fontSize
			fontSize *= 0.63 // Reduce font size by a factor of 0.63
		}

		// As of now, Show does not use post script name, so for Show 'hasPostScriptName' should always be false.
		let fontPostScriptName: String
		if self.hasPostScriptName {
			fontPostScriptName = postScriptName
		} else {
			fontPostScriptName = font.getFontId(forStyle: styleId, using: config)
		}
#if os(iOS) || os(tvOS) || os(watchOS)
		if let uiFont = UIFont(name: fontPostScriptName, size: fontSize) {
			attributes[.font] = uiFont
		} else {
			attributes[.font] = UIFont(name: "AvenirNext-Regular", size: fontSize)
		}
#else
		if let nsFont = NSFont(name: fontPostScriptName, size: fontSize) {
			attributes[.font] = nsFont
		} else {
			attributes[.font] = NSFont(name: "HelveticaNeue", size: fontSize)
		}
#endif
		if hasFont, font.hasFontFamily, font.fontFamily.hasName {
			// NOTE: Presentations imported from Keynote contains font family different from
			// the ones available in device for same font
			// To handle this scenario, font family in proto is included in attributes
			attributes[.zsFontFamilyInProto] = font.fontFamily.name
		}
	}
}

public extension PortionProps {
	/// A string to represent font weight and its style
	var styleId: String {
		var styleId = (!hasFontweight && bold) ? "700" : "400" // set default font-weight to ".normal"
		if hasFontweight {
			styleId = fontweight.styleId
		}
		if italic {
			styleId = styleId.appending("i")
		}
		return styleId
	}

	func getHighlightColor(with alpha: CGFloat) -> DeviceColor? {
		guard self.hasHighlight, self.highlight.type != .none else {
			return nil
		}
		return self.highlight.solid.color.platformColor.withAlphaComponent(alpha)
	}
}

public extension TextLayerProperties {
	var singleSolidFill: Fill? {
		guard self.strokes.isEmpty,
		      self.effects.shadows.isEmpty,
		      self.alpha == 0.0,
		      !self.hasBlur,
		      self.blend == .normal,
		      !self.hasStyleRef else {
			return nil
		}
		let visibleFills = self.fills.filter { !$0.hidden }
		if visibleFills.count == 1, visibleFills[0].type == .solid {
			return visibleFills[0]
		} else {
			return nil
		}
	}
}

public extension TextAttributes {
	mutating func updateBackgroundColor() {
		var newColor: DeviceColor?
		if let highlightColor = self[.zsHighlightBGColor] as? DeviceColor {
			newColor = highlightColor
		}
		if let dataFieldsBGColor = self[.zsDataFieldsBGColor] as? DeviceColor {
			if let updatedColor = newColor {
				// 0.4 is the alpha for data field
				newColor = updatedColor.blend(with: dataFieldsBGColor, alpha: 0.3)
			} else {
				newColor = dataFieldsBGColor
			}
		}
		self[.backgroundColor] = newColor
	}
}
