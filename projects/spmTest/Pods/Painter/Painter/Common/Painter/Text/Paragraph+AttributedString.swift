//
//  Paragraph+AttributedString.swift
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

public extension Paragraph {
	func draw(inContext ctx: RenderingContext, withGroupProps groupProps: Properties?) {
		// TODO: construct 'NSMutableAttributedString' and draw it to the context
	}

	func getAttributedString(
		forBulletIndex bulletIndex: Int,
		with scaleProps: ScaleProps,
		and textStyleProps: TextBoxProps.TextStyleProps.TextProperties?,
		using config: PainterConfig?,
		canUseParaSpacing: (before: Bool, after: Bool),
		casedString: Bool,
		bulletFree: Bool,
		forShapeId shapeId: String? = nil) -> NSMutableAttributedString {
		let attributedString = NSMutableAttributedString()

		// Add list style attributes
		let paragraphStyle = getBulletParagraphStyle(
			for: attributedString,
			forBulletIndex: bulletIndex,
			with: scaleProps,
			using: config,
			bulletFree: bulletFree)

		self.addPortions(
			to: attributedString,
			fontScale: scaleProps.fontScale,
			textStyleProps: textStyleProps,
			casedString: casedString,
			config: config,
			forShapeId: shapeId)

		self.style.setParaStyle(
			to: attributedString,
			with: paragraphStyle,
			and: scaleProps,
			canUseParaSpacing: canUseParaSpacing)

		return attributedString
	}

	var hasBullet: Bool {
		guard
			self.hasStyle,
			self.style.hasBullet
		else {
			return false
		}
		return true
	}
}

private extension Paragraph {
	func getBulletParagraphStyle(
		for attributedString: NSMutableAttributedString,
		forBulletIndex bulletIndex: Int,
		with scaleProps: ScaleProps,
		using config: PainterConfig?,
		bulletFree: Bool) -> NSMutableParagraphStyle {
		// Add list style attributes
		guard let firstPortion = self.portions.first else {
			return NSMutableParagraphStyle()
		}
		let portionHasT = (firstPortion.hasT && !firstPortion.t.isEmpty)
		let portionHasDataField = firstPortion.hasField &&
			firstPortion.field.hasType &&
			firstPortion.field.type == .datafield &&
			firstPortion.field.hasDatafieldID
		return self.style.setListStyle(
			for: attributedString,
			atIndex: (portionHasT || portionHasDataField) ? bulletIndex : Int.max,
			with: firstPortion.fontProps,
			and: scaleProps,
			bulletFree: bulletFree,
			using: config)
	}

	func addPortions(
		to attributedString: NSMutableAttributedString,
		fontScale: Float,
		textStyleProps: TextBoxProps.TextStyleProps.TextProperties?,
		casedString: Bool,
		config: PainterConfig?,
		forShapeId shapeId: String?) {
		for portion in portions {
			var dataFieldInfo = PainterConfig.DataFieldInfo.default

			if portion.hasField,
			   portion.field.hasType,
			   portion.field.type == .datafield,
			   portion.field.hasDatafieldID,
			   let info = config?.getDataFieldInfo(
			   	forDataLinkId: portion.field.datafieldID,
			   	shapeId: shapeId) {
				dataFieldInfo = info
			}

			let rawString = portion.rawString(
				using: config,
				casedString: casedString,
				dataField: dataFieldInfo.value)

			let portionAttributes = portion.props.getAttributes(
				withFontScale: fontScale,
				withTextStyleProps: textStyleProps,
				using: config,
				casedString: casedString,
				shapeId: shapeId,
				dataFieldBgColor: dataFieldInfo.bgColor)

			let portionAttributedString = NSMutableAttributedString(string: rawString, attributes: portionAttributes)
			attributedString.append(portionAttributedString)
		}
	}
}
