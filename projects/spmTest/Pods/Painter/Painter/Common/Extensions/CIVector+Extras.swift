//
//  CIVector+Extras.swift
//  Painter
//
//  Created by karthikeyan gm on 25/04/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

#if !os(watchOS)
import CoreImage
import Foundation

extension CIVector {
	convenience init(x: CGFloat) {
		self.init(x: x, y: 0, z: 0, w: 0)
	}

	convenience init(y: CGFloat) {
		self.init(x: 0, y: y, z: 0, w: 0)
	}

	convenience init(z: CGFloat) {
		self.init(x: 0, y: 0, z: z, w: 0)
	}

	convenience init(w: CGFloat) {
		self.init(x: 0, y: 0, z: 0, w: w)
	}
}
#endif
