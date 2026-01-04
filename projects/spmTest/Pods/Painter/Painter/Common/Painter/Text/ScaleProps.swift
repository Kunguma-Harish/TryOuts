//
//  ScaleProps.swift
//  Painter
//
//  Created by Sarath Kumar G on 02/12/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation

public struct ScaleProps {
	public let fontScale: Float
	public let lineSpaceScale: Float

	public init(fontScale: Float? = nil, lineSpaceScale: Float? = nil) {
		self.fontScale = fontScale ?? 1.0
		self.lineSpaceScale = lineSpaceScale ?? 0.0
	}
}

public extension ScaleProps {
	var inverted: ScaleProps {
		return ScaleProps(fontScale: 1.0 / self.fontScale, lineSpaceScale: 1.0 / self.lineSpaceScale)
	}

	func applyingScale(_ scale: CGFloat) -> ScaleProps {
		return ScaleProps(
			fontScale: self.fontScale * Float(scale),
			lineSpaceScale: self.lineSpaceScale * Float(scale))
	}
}
