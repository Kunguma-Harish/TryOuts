//
//  Effects+DrawHelper.swift
//  Painter
//
//  Created by Sarath Kumar G on 28/04/20.
//  Copyright © 2020 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

extension Effects.Shadow {
	var shadowAngle: CGFloat {
		switch self.type {
		case .inner:
			return 180 - CGFloat(self.distance.angle)
		case .outer:
			return CGFloat(-self.distance.angle)
		}
	}
}
