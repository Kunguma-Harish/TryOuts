//
//  TextboxProps+Helpers.swift
//  Painter
//
//  Created by Sarath Kumar G on 02/12/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

#if !os(macOS)
import CoreGraphics
#endif
import Foundation
import Proto

public extension TextBoxProps {
	var scaleProps: ScaleProps {
		return ScaleProps(fontScale: self.fontScale, lineSpaceScale: self.lineSpaceScale)
	}

	func getInset(withScale: Bool) -> Margin {
		let scale = !(withScale || self.fontScale == 0.0) ? 1.0 : self.fontScale
		return (hasInset ? inset : Margin.default).applyingScale(scale)
	}

#if os(macOS)
	/// Considers origin to be top left of the rectangle i.e a flipped coordinate system.
	func getInsetRect(for rect: CGRect) -> CGRect {
		let insets = self.getInset(withScale: true) // self.insetWithScale
		var insetRect = rect
		let leftInset = CGFloat(insets.left)
		insetRect.origin.x += leftInset
		insetRect.size.width -= leftInset
		let rightInset = CGFloat(insets.right)
		insetRect.size.width -= rightInset
		let topInset = CGFloat(insets.top)
		insetRect.origin.y += topInset
		insetRect.size.height -= topInset
		let bottomInset = CGFloat(insets.bottom)
		insetRect.size.height -= bottomInset

		return (insetRect.isNull || insetRect.isInfinite) ? rect : insetRect
	}

#else
	func getInsetRect(for rect: CGRect) -> CGRect {
		let insetRect = rect.inset(by: self.getInset(withScale: true).edgeInsets)
		return (insetRect.isNull || insetRect.isInfinite) ? rect : insetRect
	}
#endif

	func getTextOrigin(from shapeBbox: CGRect, and calculatedHeight: CGFloat) -> CGPoint {
		let valign = self.hasValign ? self.valign : PainterConfig.defaultVerticalTextAlignment
		let diff = (shapeBbox.height - calculatedHeight) / 2
		var textOrigin = shapeBbox.origin

		textOrigin = CGPoint(x: shapeBbox.origin.x, y: shapeBbox.origin.y + diff) // vertical align middle

		if valign == .top { // vertical align top
			textOrigin = CGPoint(shapeBbox.origin.x, shapeBbox.origin.y)
		}
		if valign == .bottom { // vertical align bottom
			textOrigin = CGPoint(shapeBbox.origin.x, shapeBbox.origin.y + shapeBbox.height - calculatedHeight)
		}
		return textOrigin
	}
}

private extension TextBoxProps {
	var lineSpaceScale: Float {
		if hasAutoFit, autoFit.hasType, autoFit.type == .normal, autoFit.normal.hasLineSpaceScale {
			return autoFit.normal.lineSpaceScale
		}
		return 0.0
	}

	var fontScale: Float {
		if hasAutoFit, autoFit.hasType, autoFit.type == .normal, autoFit.normal.hasFontScale {
			return autoFit.normal.fontScale
		}
		return 1.0
	}
}
