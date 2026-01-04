//
//  TextBody+Draw.swift
//  Painter
//
//  Created by Sarath Kumar G on 16/08/17.
//  Copyright © 2017 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation
import Proto

#if os(iOS) || os(tvOS)
import UIKit.NSTextStorage
#elseif os(watchOS)
import UIKit.NSAttributedString
#else
import AppKit.NSTextStorage
#endif

#if os(iOS) || os(tvOS) || os(watchOS)
public typealias DeviceFont = UIFont
public typealias DeviceImage = UIImage
#else
public typealias DeviceFont = NSFont
public typealias DeviceImage = NSImage
#endif

public extension TextBody {
	/// Draw the text contents contained by the 'TextBody'
	func draw(inside rect: CGRect, forId: String, using config: PainterConfig?) { // TextKit draw()
		self.drawGlyphs(enclosing: rect, using: config, for: forId)
	}

	/// Construct 'NSMutableAttributedString' out of the array of 'Paragraph' objects contained by a 'TextBody'
	func textAttributedString(
		using config: PainterConfig? = nil,
		casedString: Bool = true,
		bulletFree: Bool = false,
		forShapeId shapeId: String? = nil) -> NSMutableAttributedString {
		let finalString = NSMutableAttributedString()
		let scaleProps = self.props.scaleProps
		let textStyleProps = self.props.textStyle.props

		for paraIndex in 0..<paras.count {
			let para = paras[paraIndex]
			let bulletIndex = getBulletIndex(forIndex: paraIndex)
			finalString.append(
				para.getAttributedString(
					forBulletIndex: bulletIndex,
					with: scaleProps,
					and: textStyleProps,
					using: config,
					canUseParaSpacing: (true, true),
					casedString: casedString,
					bulletFree: bulletFree,
					forShapeId: shapeId)
			)

			if paraIndex < (paras.count - 1) {
				if para.portions.count == 1, !(para.portions[0].hasT || (para.portions[0].hasField && para.portions[0].field.hasType && para.portions[0].field.type == .datafield)) {
					finalString.replaceCharacters(in: NSRange(location: finalString.length - 1, length: 1), with: "\n")
				} else {
					let attributes = finalString.attributes(at: finalString.length - 1, effectiveRange: nil)
					finalString.append(NSMutableAttributedString(string: "\n", attributes: attributes))
				}
			}
		}
		return finalString
	}

	func getParaAttributedString(
		at paraIndex: Int,
		textStyleProps: TextBoxProps.TextStyleProps.TextProperties? = nil,
		using config: PainterConfig? = nil,
		casedString: Bool = true,
		bulletFree: Bool = false) -> NSMutableAttributedString {
		return paras[paraIndex].getAttributedString(
			forBulletIndex: getBulletIndex(forIndex: paraIndex),
			with: self.props.scaleProps,
			and: textStyleProps,
			using: config,
			canUseParaSpacing: (before: paraIndex > 0, after: paraIndex < paras.count - 1),
			casedString: casedString,
			bulletFree: bulletFree)
	}

	func getTextBoxFrame(enclosedBy rect: CGRect, forId: String, using config: PainterConfig? = nil) -> CGRect {
		let shapeBbox = props.getInsetRect(for: rect)
		var targetSize = CGSize.zero
		var textOrigin = CGPoint.zero

#if os(watchOS)
		let attributedString = getAttributedStringFromCache(forId: forId, using: config)
		targetSize = attributedString.size()
		textOrigin = getTextOrigin(from: shapeBbox, and: targetSize.height)
#else
		let size = CGSize(width: shapeBbox.width, height: CGFloat.greatestFiniteMagnitude)
		let textStorage = self.getTextStorageFromCache(forId: forId, size: size, using: config)
		if let layoutManager = textStorage.layoutManagers.first,
		   let textContainer = layoutManager.textContainers.first {
			let calculatedFrame = layoutManager.usedRect(for: textContainer)
			targetSize = calculatedFrame.size // props.getInsetRect(forRect: calculatedFrame).size
			textOrigin = getTextOrigin(from: shapeBbox, and: calculatedFrame.height) + calculatedFrame.origin
		}
#endif

		let inset = props.getInset(withScale: true)
		targetSize.width += CGFloat(inset.left + inset.right)
		targetSize.height += CGFloat(inset.top + inset.bottom)
		return CGRect(origin: textOrigin, size: targetSize)
	}

	/// Get frame surrounding the text contents relative to given Rect
	///
	/// - Parameter rect: Enclosing CGRect within which text contents has to be rendered
	/// - Returns: CGRect specifying exact size (width and height) required to hold the text contents
	func getTextBoxExactFrame(enclosedBy rect: CGRect) -> CGRect {
		var textFrame = props.getInsetRect(for: rect)
		_ = getCTFrame(for: self.textAttributedString(), inside: &textFrame)
		//        return textFrame
		let inset = props.getInset(withScale: true)
		let heightOffset = CGFloat(inset.top + inset.bottom) // Include TextBox insets
		return CGRect(origin: textFrame.origin, size: CGSize(width: textFrame.width, height: textFrame.height + heightOffset))
	}

	static func getContentSize(for attrbString: NSAttributedString, basedOn frame: CGRect, shouldWrapText: Bool) -> CGSize {
		let usedRect = self.getContentRect(for: attrbString, basedOn: frame, shouldWrapText: shouldWrapText)
		return usedRect.size
	}

	static func getContentRect(for attrbString: NSAttributedString, basedOn frame: CGRect, shouldWrapText: Bool) -> CGRect {
#if os(iOS) || os(tvOS) || os(macOS)
		let approxSize = CGSize(width: shouldWrapText ? frame.width : CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
		// Cannot use cached Text Storage as string can be different from what is cached
		let textStorage = NSTextStorage(attributedString: attrbString)
		let textContainer = NSTextContainer(size: approxSize)
		textContainer.lineFragmentPadding = 0.0
		let layoutManager = ZSLayoutManager()
		layoutManager.addTextContainer(textContainer)
		textStorage.addLayoutManager(layoutManager)
		layoutManager.ensureLayout(for: textContainer)
		let usedRect = layoutManager.usedRect(for: textContainer)
		return usedRect
#else
		return .zero
#endif
	}
}

public extension TextBody {
	/// Checks whether the two 'Paragraph' objects for given indices in 'TextBody' has the same bullet type
	func isBulletTypeSame(forIndex curIndex: Int, andIndex prevIndex: Int) -> Bool {
		let curBullet = paras[curIndex].style.listStyle.bullet
		let prevBullet = paras[prevIndex].style.listStyle.bullet

		return (curBullet.type == .number && prevBullet.type == .number) ?
			curBullet.number.type == prevBullet.number.type : curBullet.type == prevBullet.type
	}

	/// Computes equivalent Bullet index for given 'Paragraph' index
	func getBulletIndex(forIndex paraIndex: Int) -> Int {
		let para = paras[paraIndex]

		// Return if the bullet type is not 'Number'. Other bullet types doesn't require this calculation
		if para.style.listStyle.bullet.type != .number {
			return 1
		}

		var prevLevel = -1
		let paraLevel = Int(para.style.level)

		// consider 'startAt' value for calculating bullet index
		var bulletIndex = para.style.listStyle.bullet.hasNumber ? Int(para.style.listStyle.bullet.number.startat) : 1

		for index in 0..<paraIndex {
			let curPara = paras[index]
			let curLevel = Int(curPara.style.level)
			let portionLength = curPara.portions[0].t.count

			// Also check for bullet type mismatch for the current and previous paragraphs to reset 'bulletIndex'
			if (prevLevel > curLevel && paraLevel > curLevel) ||
				(index > 0 && curLevel == paraLevel && !self.isBulletTypeSame(forIndex: index, andIndex: index - 1)) {
				// consider 'startAt' value for calculating bullet index
				bulletIndex = para.style.listStyle.bullet.hasNumber ? Int(para.style.listStyle.bullet.number.startat) : 1
			}
			if portionLength > 0 {
				// Along with para levels, bullet type should also be the same. Only then 'bulletIndex' should be incremented
				if curLevel == paraLevel, self.isBulletTypeSame(forIndex: index, andIndex: paraIndex) {
					bulletIndex += 1
				}
				prevLevel = curLevel
			}
		}
		return bulletIndex
	}

	/// Creates CTFrame inside which the attributed string (text content) has to be drawn
	///
	/// - Parameters:
	///   - attrbString: Attributed String for which CTFrame has to be created
	///   - textFrame: Frame enclosing attributed string
	/// - Returns: CTFrame created out of attributed string and the frame enclosing it
	func getCTFrame(for attrbString: NSMutableAttributedString, inside textFrame: inout CGRect) -> CTFrame {
		let frameSetter = CTFramesetterCreateWithAttributedString(attrbString)
		let stringRange = CFRange(location: 0, length: attrbString.length)
		let targetSize = CGSize(width: textFrame.size.width, height: CGFloat.greatestFiniteMagnitude)
		let suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, stringRange, nil, targetSize, nil)
		let suggestedHeight = suggestedSize.height
		let textFrameHeight = textFrame.size.height
		var textPathBbox = textFrame
		let valign = props.hasValign ? props.valign : PainterConfig.defaultVerticalTextAlignment

		textFrame.size.height = suggestedHeight
		var textPath = CGPath(rect: textFrame, transform: nil)

		if suggestedHeight < textFrameHeight {
			let diff = (textFrameHeight - suggestedHeight) / 2
			var newOrigin = CGPoint(x: textPathBbox.origin.x, y: textPathBbox.origin.y + diff) // vertical align center

			if valign == .top {
				// vertical top align in iOS coordinate system (vertical align bottom in macOS coordinate system)
				newOrigin = CGPoint(x: textPathBbox.origin.x, y: textPathBbox.origin.y)
			}
			if valign == .bottom {
				// vertical bottom align in iOS coordinate system (vertical align top in macOS coordinate system)
				newOrigin = CGPoint(x: textPathBbox.origin.x, y: textPathBbox.origin.y + textPathBbox.size.height - suggestedHeight)
			}

			//            textPathBbox = CGRect(origin: newOrigin, size: suggestedSize)
			textPathBbox = CGRect(x: newOrigin.x, y: newOrigin.y, width: textFrame.size.width, height: suggestedHeight)
			textFrame = textPathBbox
			textPath = CGPath(rect: textPathBbox, transform: nil)
		}
		return CTFramesetterCreateFrame(frameSetter, CFRange(location: 0, length: 0), textPath, nil)
	}

	func drawGlyphs(enclosing rect: CGRect, using config: PainterConfig?, for id: String) {
		let shapeBbox = getTextBbox(from: rect)

#if os(watchOS)
		let attributedString = self.getAttributedStringFromCache(forId: id, using: config)
		let textOrigin = self.getTextOrigin(from: shapeBbox, and: attributedString.size().height)
		// TODO: Is usesFontLeading in drawing options required for Show?
		attributedString.draw(
			with: CGRect(origin: textOrigin, size: attributedString.size()),
			options: NSStringDrawingOptions.usesLineFragmentOrigin,
			context: nil)
#else
		let size = CGSize(
			width: self.getWidthBasedOnWrap(actual: shapeBbox.width, forId: id, config: config),
			height: .greatestFiniteMagnitude)
		let textStorage = self.getTextStorageFromCache(forId: id, size: size, using: config)
		let layoutManager = textStorage.layoutManagers[0]
		let textContainer = layoutManager.textContainers[0]
		(layoutManager as? ZSLayoutManager)?.shapeObjectFrame = shapeBbox
		(layoutManager as? ZSLayoutManager)?.pictureFillConfig = config?.getPicturFillOnlyConfig()

		let glyphRange = layoutManager.glyphRange(for: textContainer)
		let calculatedFrame = layoutManager.usedRect(for: textContainer)
		let textOrigin = self.getTextOrigin(from: shapeBbox, and: calculatedFrame.height)

		if self.shouldDrawBackground {
			layoutManager.drawBackground(forGlyphRange: glyphRange, at: textOrigin)
		}
		layoutManager.drawGlyphs(forGlyphRange: glyphRange, at: textOrigin)
#endif
	}

#if !os(watchOS)
	func getTextStorageFromCache(forId: String, size: CGSize, using config: PainterConfig?) -> NSTextStorage {
		let textStorage: NSTextStorage
		if let cachedTextStorage = config?.cache?.getTextStorage(for: forId, and: size) {
			textStorage = cachedTextStorage
		} else {
			let attrString = self.getAttributedStringFromCache(forId: forId, using: config)

			let layoutManager = ZSLayoutManager()
			textStorage = NSTextStorage(attributedString: attrString)
			let textContainer = NSTextContainer(size: size)
			textContainer.lineFragmentPadding = 0.0
			layoutManager.addTextContainer(textContainer)
			textStorage.addLayoutManager(layoutManager)
			layoutManager.ensureLayout(for: textContainer)
			config?.cache?.setTextStorageMap(for: forId, textStorage: textStorage, with: size)
		}
		return textStorage
	}
#endif
}

// MARK: - Text + CGPath

public extension TextBody {
	func getImageBounds(forRect rect: CGRect, id shapeID: String, using config: PainterConfig?) -> CGRect {
#if os(watchOS)
		return rect
#else

		if let bounds = config?.cache?.getTextBounds(for: shapeID) {
			return bounds
		}
		var frame = rect
		let attrString = getAttributedStringFromCache(forId: shapeID, using: config)
		let ctFrame = self.getCTFrame(for: attrString, inside: &frame)

		var lineOrigins = [CGPoint]()
		let size = CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude)
		let textStorage = self.getTextStorageFromCache(forId: shapeID, size: size, using: config)
		let layoutManager = textStorage.layoutManagers[0]
		var index = 0, numberOfGlyphs = layoutManager.numberOfGlyphs
		while index < numberOfGlyphs {
			var lineRange = NSRange()
			let lineRect = layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
			index = NSMaxRange(lineRange)
			lineOrigins.append(lineRect.origin)
		}

		var bounds = CGRect.null
		if let ctLines = CTFrameGetLines(ctFrame) as? [CTLine],
		   ctLines.count == lineOrigins.count {
			for (i, line) in ctLines.enumerated() {
				var lineBounds = CTLineGetImageBounds(line, nil)
				lineBounds.origin.x = lineOrigins[i].x + lineBounds.origin.x
				lineBounds.origin.y = lineOrigins[i].y - lineBounds.origin.y
				bounds = bounds.union(lineBounds)
			}
//				bounds.origin += rect.origin
			bounds.center = rect.center
		} else {
			Debugger.debug("failed to calculate bounds for text")
		}

		config?.cache?.setTextBounds(for: shapeID, bounds: bounds)
		return bounds
#endif
	}
}

extension TextBody {
	func getTextOrigin(from shapeBbox: CGRect, and calculatedHeight: CGFloat) -> CGPoint {
		return self.props.getTextOrigin(from: shapeBbox, and: calculatedHeight)
	}

	func getAttributedStringFromCache(forId: String, using config: PainterConfig?) -> NSMutableAttributedString {
		let finalString: NSMutableAttributedString
		if let attributedString = config?.cache?.getAttributedStringMap(for: forId) {
			finalString = attributedString
		} else {
			finalString = self.textAttributedString(using: config, forShapeId: forId)
			config?.cache?.setAttributedStringMap(for: forId, attributedString: finalString)
		}
		return finalString
	}

#if !os(watchOS)
	/// Paths are generated for infinite height Text Container size.
	/// The text container size is constructed with the width of the input frame and infinite height.
	/// The input frame should be finite, since it is used to calculate text origin if there is vertical alignment.
	/// This means text contents beyond the bounds of the frame will also be part of the result.
	public func getTextAsPaths(withFrame frame: CGRect, id shapeID: String, using config: PainterConfig?, charactersRequired: Bool) -> [TextAsPath] {
		if !charactersRequired, let storedPathData = config?.cache?.getTextAsPathMap(for: shapeID) {
			return self.getTranslatedTextAsPaths(storedData: storedPathData, newOrigin: frame.origin)
		} else {
			let infiniteSize = CGSize(
				width: self.getWidthBasedOnWrap(actual: frame.width, forId: shapeID, config: config),
				height: .greatestFiniteMagnitude)
			let textStorage = self.getTextStorageFromCache(forId: shapeID, size: infiniteSize, using: config)
			let layoutManager = textStorage.layoutManagers[0]
			let textContainer = layoutManager.textContainers[0]
			let glyphRange = layoutManager.glyphRange(for: textContainer)
			let calculatedFrame = layoutManager.usedRect(for: textContainer)
			let textBodyOrigin = self.getTextOrigin(from: frame, and: calculatedFrame.height)
			let diff = textBodyOrigin.y - frame.origin.y
			let textLayoutOrigin = CGPoint(x: frame.origin.x, y: frame.origin.y + diff)

			let textAsPaths = layoutManager.getTextAsPaths(forGlyphRange: glyphRange, at: textLayoutOrigin, charactersRequired: charactersRequired)

			if !charactersRequired {
				config?.cache?.setTextAsPathMap(for: shapeID, value: (textAsPaths, frame.origin))
			}
			return textAsPaths
		}
	}
#endif

	func getTranslatedTextAsPaths(storedData: (paths: [TextAsPath], origin: CGPoint), newOrigin: CGPoint) -> [TextAsPath] {
		let translation = CGPoint(
			x: CGFloat(newOrigin.x - storedData.origin.x),
			y: CGFloat(newOrigin.y - storedData.origin.y))

		var transformedPaths = [TextAsPath]()
		for runOfPaths in storedData.paths {
			var newPaths = [CGPath]()
			for path in runOfPaths.paths {
				var cgAffineTransfrom = CGAffineTransform
					.identity
					.translatedBy(x: translation.x, y: translation.y)
				guard let transformedPath = path.copy(using: &cgAffineTransfrom) else {
					assertionFailure()
					continue
				}
				newPaths.append(transformedPath)
			}
			var newValue = runOfPaths
			newValue.paths = newPaths
			transformedPaths.append(newValue)
		}
		return transformedPaths
	}

	func isEmpty(id: String, using config: PainterConfig? = nil) -> Bool {
		let attributedString = self.getAttributedStringFromCache(forId: id, using: config)
		return attributedString.string.isEmpty
	}

	var shouldDrawBackground: Bool {
		self.paras.contains { para in
			para.portions.contains { portion in
				let hasDataField = portion.hasField &&
					portion.field.hasType &&
					portion.field.type == .datafield
				let hasHighlight = portion.hasProps &&
					portion.props.hasHighlight &&
					portion.props.highlight.type != .none
				return hasDataField || hasHighlight
			}
		}
	}
}
