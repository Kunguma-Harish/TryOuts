//
//  Transform+RectHelper.swift
//  Painter
//
//  Created by Sarath Kumar G on 26/02/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation
import Proto

public extension Transform {
	var hasRotationAngle: Bool {
		return hasRotAngle || hasRotate
	}

	var rotationAngle: Float {
		get {
			return hasRotAngle ? rotAngle : (hasRotate ? Float(rotate) : 0)
		}
		set {
			rotAngle = newValue
			rotate = Int32(newValue)
		}
	}

	mutating func clearRotationAngle() {
		clearRotAngle()
		clearRotate()
	}
}
