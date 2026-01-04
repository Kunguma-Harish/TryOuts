//
//  FBCurveLocation.swift
//  Swift VectorBoolean for iOS
//
//  Based on FBCurveLocation - Created by Andrew Finnell on 6/18/13.
//  Copyright (c) 2013 Fortunate Bear, LLC. All rights reserved.
//
//  Created by Leslie Titze on 2015-07-06.
//  Copyright (c) 2015 Leslie Titze. All rights reserved.
//

import CoreGraphics
import Foundation

public class FBCurveLocation {
	var graph: FBBezierGraph?
	var contour: FBBezierContour?
	private var _edge: FBBezierCurve
	private var _parameter: Double
	private var _distance: Double

	init(edge: FBBezierCurve, parameter: Double, distance: Double) {
		self._edge = edge
		self._parameter = parameter
		self._distance = distance
	}

	public var edge: FBBezierCurve {
		return self._edge
	}

	public var parameter: Double {
		return self._parameter
	}

	var distance: Double {
		return self._distance
	}
}
