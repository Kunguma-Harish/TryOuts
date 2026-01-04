//
//  NSLayoutManager+TextPath.swift
//  Painter
//
//  Created by Sarath Kumar G on 28/03/20.
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

extension NSLayoutManager {
	func getTextAsPaths(forGlyphRange glyphRange: NSRange, at origin: CGPoint, charactersRequired: Bool, onlyUnderlineStrikethrough: Bool = false) -> [TextAsPath] {
		guard let textStorage = self.textStorage else {
			assertionFailure()
			return []
		}

		var actualGlyphRange = NSRange()
		let charRange = self.characterRange(forGlyphRange: glyphRange, actualGlyphRange: &actualGlyphRange)
		// Development purpose: make sure there isn't a case where actual glyph range exceeds given range.
		assert(actualGlyphRange == glyphRange)
		var textAsPaths = [TextAsPath]()

		if !onlyUnderlineStrikethrough {
			textStorage.enumerateAttributes(in: charRange) { attributes, attributesCharRange, _ in
				guard let font = attributes[.font] as? DeviceFont else {
					assertionFailure()
					return
				}
				let textLayerProps = attributes[.zsTextLayerProps] as? TextLayerProperties ?? TextLayerProperties()
				let attributesGlyphRange = self.glyphRange(forCharacterRange: attributesCharRange, actualCharacterRange: nil)
				var paths: [CGPath] = []
				var characters: [String] = []

				for glyphIndex in attributesGlyphRange.location..<NSMaxRange(attributesGlyphRange) {
					let lineFragmentRect = self.lineFragmentRect(forGlyphAt: glyphIndex, effectiveRange: nil)
					var layoutLocation = self.location(forGlyphAt: glyphIndex)

					layoutLocation.x += lineFragmentRect.origin.x + origin.x
					layoutLocation.y += lineFragmentRect.origin.y + origin.y

					let glyph = self.cgGlyph(at: glyphIndex)

#if os(macOS)
					let canGeneratePath = glyph != NSNullGlyph && glyph != NSControlGlyph
#else
					let canGeneratePath = self.propertyForGlyph(at: glyphIndex) != .null
#endif

					if canGeneratePath {
						var trans = CGAffineTransform.identity
							.translatedBy(x: layoutLocation.x, y: layoutLocation.y)
							.scaledBy(x: 1, y: -1)
						guard let path = CTFontCreatePathForGlyph(font, glyph, &trans) else {
							continue
						}
						paths.append(path)

						if charactersRequired {
							var actualGlyphRange = NSRange()
							let charRange = self.characterRange(forGlyphRange: NSRange(location: glyphIndex, length: 1), actualGlyphRange: &actualGlyphRange)
							if let name = textStorage.getAttributedSubString(from: charRange)?.string {
								characters.append(name)
							}
						}
					}
				}
				if !paths.isEmpty {
					textAsPaths.append(TextAsPath(paths: paths, characters: characters, textLayerProps: textLayerProps))
				}
			}
		}

		// TODO: Test for correctness both underline and strikethrough
		let underlinePaths = self.getUnderlinePaths(charRange: charRange, origin: origin, charactersRequired: charactersRequired)
		textAsPaths.append(contentsOf: underlinePaths)

		let strikethroughPaths = self.getStrikethroughPaths(charRange: charRange, origin: origin, charactersRequired: charactersRequired)
		textAsPaths.append(contentsOf: strikethroughPaths)

		return textAsPaths
	}

	func getUnderlinePaths(charRange: NSRange, origin: CGPoint, charactersRequired: Bool) -> [TextAsPath] {
		guard let textStorage = self.textStorage else {
			assertionFailure()
			return []
		}
		var underlinePaths = [TextAsPath]()

		// Loop through each range of layer props
		textStorage.enumerateAttribute(.zsTextLayerProps, in: charRange) { layerPropsValue, layerPropsCharRange, _ in
			let layerPropsGlyphRange = self.glyphRange(forCharacterRange: layerPropsCharRange, actualCharacterRange: nil)
			if let layerProps = layerPropsValue as? TextLayerProperties {
				var paths = [CGPath]()

				// Loop through each line
				self.enumerateLineFragments(forGlyphRange: layerPropsGlyphRange) { lineRect, _, _, lineGlyphRange, _ in
					// Line glyph range can exceed layer props glyph range
					guard let intersectionRange = layerPropsGlyphRange.intersection(lineGlyphRange) else {
						return
					}
					let lineCharRange = self.characterRange(forGlyphRange: intersectionRange, actualGlyphRange: nil)

					// Loop through each range of underline value
					textStorage.enumerateAttribute(.underlineStyle, in: lineCharRange) { underlineValue, underlineCharRange, _ in
						if let underlineIntValue = underlineValue as? Int {
							let underlineStyle = NSUnderlineStyle(rawValue: underlineIntValue)
							let underlineGlyphRange = self.glyphRange(forCharacterRange: underlineCharRange, actualCharacterRange: nil)
							guard let underlinePath = self.getUnderlinePath(forGlyphRange: underlineGlyphRange, underlineType: underlineStyle, underlineCharacterRange: underlineCharRange, lineFragmentRect: lineRect, containerOrigin: origin) else {
								return
							}
							paths.append(underlinePath)
						}
					}
				}
				if !paths.isEmpty {
					var characters = [String]()
					if charactersRequired {
						for i in 0..<paths.count {
							characters.append("Underline \(i)")
						}
					}
					underlinePaths.append(TextAsPath(paths: paths, characters: characters, textLayerProps: layerProps))
				}
			}
		}

		return underlinePaths
	}

	func getUnderlinePath(forGlyphRange glyphRange: NSRange, underlineType underlineVal: NSUnderlineStyle, underlineCharacterRange charRange: NSRange, lineFragmentRect lineRect: CGRect, containerOrigin: CGPoint) -> CGPath? {
		guard underlineVal == .single else {
			return nil
		}
		guard let textStorage = self.textStorage else {
			return nil
		}

		let (_, correspondingFont) = textStorage.getMaxBaselineOffset(range: charRange)
		let underlinePosition = CTFontGetUnderlinePosition(correspondingFont as CTFont)
		let underlineThickness = CTFontGetUnderlineThickness(correspondingFont as CTFont)
		let underlineYFromBaseline = -underlinePosition - (underlineThickness / 2)

		var underlineOrigin = self.location(forGlyphAt: glyphRange.location)
		underlineOrigin.x += lineRect.origin.x + containerOrigin.x
		underlineOrigin.y += underlineYFromBaseline + lineRect.origin.y + containerOrigin.y
		var underlineWidth: CGFloat = 0
		for index in glyphRange.location..<NSMaxRange(glyphRange) {
			let charIndex = self.characterIndexForGlyph(at: index)
			let attributes = textStorage.attributes(at: charIndex, effectiveRange: nil)
			guard let font = attributes[.font] as? DeviceFont else {
				assertionFailure()
				continue
			}

			let glyphProperty = self.propertyForGlyph(at: index)
			if glyphProperty != .null, glyphProperty != .elastic, glyphProperty != .controlCharacter {
				let glyph = self.cgGlyph(at: index)
				let advancement = CTFontGetAdvancesForGlyphs(font as CTFont, .default, [glyph], nil, 1)
				let currentLayoutLocation = self.location(forGlyphAt: index)
				underlineWidth = currentLayoutLocation.x + CGFloat(advancement) - self.location(forGlyphAt: glyphRange.location).x
			}
		}

		// FIXME: Only whitespaces at the end of the line should not have underline even if set.
		// All other whtiespaces inside the line should have underline if set.
		if underlineWidth != 0 {
			let underlineSize = CGSize(width: underlineWidth, height: underlineThickness)
			let underlineRect = CGRect(origin: underlineOrigin, size: underlineSize)
			let underlinePath = CGPath(rect: underlineRect, transform: nil)
			return underlinePath
		}
		return nil
	}

	func getStrikethroughPaths(charRange: NSRange, origin: CGPoint, charactersRequired: Bool) -> [TextAsPath] {
		guard let textStorage = self.textStorage else {
			assertionFailure()
			return []
		}
		var strikethroughPaths = [TextAsPath]()

		// Loop through each range of layer props
		textStorage.enumerateAttribute(.zsTextLayerProps, in: charRange) { layerPropsValue, layerPropsCharRange, _ in
			let layerPropsGlyphRange = self.glyphRange(forCharacterRange: layerPropsCharRange, actualCharacterRange: nil)
			if let layerProps = layerPropsValue as? TextLayerProperties {
				var paths = [CGPath]()

				// Loop through each line
				self.enumerateLineFragments(forGlyphRange: layerPropsGlyphRange) { lineRect, _, _, lineGlyphRange, _ in
					// Line glyph range can exceed layer props glyph range
					guard let intersectionRange = layerPropsGlyphRange.intersection(lineGlyphRange) else {
						return
					}
					let lineCharRange = self.characterRange(forGlyphRange: intersectionRange, actualGlyphRange: nil)

					// Loop through each range of font value
					textStorage.enumerateAttribute(.font, in: lineCharRange) { fontValue, fontRange, _ in
						if let font = fontValue as? DeviceFont {
							// Loop through each range of strikethrough value
							textStorage.enumerateAttribute(.strikethroughStyle, in: fontRange) { strikethroughValue, strikethroughCharRange, _ in
								if let strikethroughIntValue = strikethroughValue as? Int {
									let strikethroughStyle = NSUnderlineStyle(rawValue: strikethroughIntValue)
									let strikethroughGlyphRange = self.glyphRange(forCharacterRange: strikethroughCharRange, actualCharacterRange: nil)
									guard let strikethroughPath = self.getStrikethroughPath(forGlyphRange: strikethroughGlyphRange, strikethroughType: strikethroughStyle, fontToUse: font as CTFont, lineFragmentRect: lineRect, containerOrigin: origin) else {
										return
									}
									paths.append(strikethroughPath)
								}
							}
						}
					}
				}
				if !paths.isEmpty {
					var characters = [String]()
					if charactersRequired {
						for i in 0..<paths.count {
							characters.append("Strikethrough \(i)")
						}
					}
					strikethroughPaths.append(TextAsPath(paths: paths, characters: characters, textLayerProps: layerProps))
				}
			}
		}

		return strikethroughPaths
	}

	func getStrikethroughPath(forGlyphRange glyphRange: NSRange, strikethroughType strikethroughVal: NSUnderlineStyle, fontToUse font: CTFont, lineFragmentRect lineRect: CGRect, containerOrigin: CGPoint) -> CGPath? {
		guard strikethroughVal == .single else {
			return nil
		}

		let strikethroughThickness = CTFontGetUnderlineThickness(font)
		let xHeight = CTFontGetXHeight(font)
		let strikethroughYFromBaseline = -(xHeight / 2) - (strikethroughThickness / 2)

		var strikethroughOrigin = self.location(forGlyphAt: glyphRange.location)
		strikethroughOrigin.x += lineRect.origin.x + containerOrigin.x
		strikethroughOrigin.y += strikethroughYFromBaseline + lineRect.origin.y + containerOrigin.y
		var strikethroughWidth: CGFloat = 0
		for index in glyphRange.location..<NSMaxRange(glyphRange) {
			let glyphProperty = self.propertyForGlyph(at: index)
			if glyphProperty != .null, glyphProperty != .elastic, glyphProperty != .controlCharacter {
				let glyph = self.cgGlyph(at: index)
				let advancement = CTFontGetAdvancesForGlyphs(font as CTFont, .default, [glyph], nil, 1)
				let currentLayoutLocation = self.location(forGlyphAt: index)
				strikethroughWidth = currentLayoutLocation.x + CGFloat(advancement) - self.location(forGlyphAt: glyphRange.location).x
			}
		}

		// FIXME: Only whitespaces at the end of the line should not have underline even if set.
		// All other whtiespaces inside the line should have underline if set.
		if strikethroughWidth != 0 {
			let strikethroughSize = CGSize(width: strikethroughWidth, height: strikethroughThickness)
			let strikethroughRect = CGRect(origin: strikethroughOrigin, size: strikethroughSize)
			let strikethroughPath = CGPath(rect: strikethroughRect, transform: nil)
			return strikethroughPath
		}
		return nil
	}
}
#endif
