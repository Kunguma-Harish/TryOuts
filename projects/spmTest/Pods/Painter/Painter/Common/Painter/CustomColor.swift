//
//  CustomColor.swift
//  Painter
//
//  Created by Pravin Palaniappan on 23/11/18.
//  Copyright © 2018 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation

#if os(macOS)
import AppKit

extension NSColor {
	convenience init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
		self.init(displayP3Red: red, green: green, blue: blue, alpha: alpha)
	}
}

extension CGColor {
	func getDisplayP3() -> CGColor {
		if let colorSpace = CGColorSpace(name: CGColorSpace.displayP3), let compnent = components {
			if let color = CGColor(colorSpace: colorSpace, components: compnent) {
				return color
			}
		}
		return self
	}
}

#elseif os(iOS) || os(tvOS) || os(watchOS)
import UIKit

extension UIColor {
	convenience init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
		self.init(displayP3Red: red, green: green, blue: blue, alpha: alpha)
	}
}

extension CGColor {
	func getDisplayP3() -> CGColor {
		if let colorSpace = CGColorSpace(name: CGColorSpace.displayP3), let compnent = components {
			if let color = CGColor(colorSpace: colorSpace, components: compnent) {
				return color
			}
		}
		return self
	}
}
#endif
