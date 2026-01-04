//
//  Margin+EdgeInset.swift
//  Painter
//
//  Created by Sarath Kumar G on 02/12/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation
import Proto

#if !os(macOS)
import UIKit
#endif

extension Margin {
	/// Default text inset values for 'Show'
	static var `default`: Margin {
		return Margin.with { margin in
			margin.top = 4.8
			margin.left = 9.6
			margin.bottom = 4.8
			margin.right = 9.6
		}
	}

#if !os(macOS)
	var edgeInsets: UIEdgeInsets {
		return UIEdgeInsets(
			top: CGFloat(self.top),
			left: CGFloat(self.left),
			bottom: CGFloat(self.bottom),
			right: CGFloat(self.right))
	}
#endif

	func applyingScale(_ scale: Float) -> Margin {
		return Margin.with { margin in
			margin.top = self.top * scale
			margin.left = self.left * scale
			margin.bottom = self.bottom * scale
			margin.right = self.right * scale
		}
	}
}
