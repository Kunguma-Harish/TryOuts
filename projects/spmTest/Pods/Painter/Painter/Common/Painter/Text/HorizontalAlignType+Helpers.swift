//
//  HorizontalAlignType+Helpers.swift
//  Painter
//
//  Created by Sarath Kumar G on 02/12/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
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

public extension HorizontalAlignType {
	/// Horizontal paragraph alignment
	var alignment: NSTextAlignment {
		switch self {
		case .center:
			return .center
		case .left:
			return .left
		case .right:
			return .right
		case .justify:
			return .justified
		case .defHorizontalAlignType:
			// not used as of now; handle appropriately in future
			return .natural
		}
	}
}
