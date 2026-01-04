//
//  DrawingContext.swift
//  Painter
//
//  Created by Jaganraj Palanivel on 25/10/17.
//  Copyright © 2017 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation
#if os(macOS)
import AppKit
#elseif os(iOS) || os(tvOS)
import UIKit
#endif

public class GraphicsContext {
#if os(macOS)
	open class var currentCGContext: CGContext? {
		return NSGraphicsContext.current?.cgContext
	}

#elseif os(iOS) || os(tvOS)
	open class var currentCGContext: CGContext? {
		return UIGraphicsGetCurrentContext()
	}
#endif
}
