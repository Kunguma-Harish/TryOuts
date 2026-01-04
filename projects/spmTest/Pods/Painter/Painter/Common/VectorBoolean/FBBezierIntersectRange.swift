//
//  FBBezierIntersectRange.swift
//  Swift VectorBoolean for iOS
//
//  Based on FBBezierIntersectRange - Created by Andrew Finnell on 11/16/12.
//  Copyright (c) 2012 Fortunate Bear, LLC. All rights reserved.
//
//  Created by Leslie Titze on 2015-06-29.
//  Copyright (c) 2015 Leslie Titze. All rights reserved.
//

import CoreGraphics
import Foundation

class FBBezierIntersectRange {
	var _curve1: FBBezierCurve
	var _parameterRange1: FBRange
	var _curve1LeftBezier: FBBezierCurve?
	var _curve1MiddleBezier: FBBezierCurve?
	var _curve1RightBezier: FBBezierCurve?

	var _curve2: FBBezierCurve
	var _parameterRange2: FBRange
	var _curve2LeftBezier: FBBezierCurve?
	var _curve2MiddleBezier: FBBezierCurve?
	var _curve2RightBezier: FBBezierCurve?

	// TODO: perhaps this should be replaced by use of the optionals
	var needToComputeCurve1 = true
	var needToComputeCurve2 = true

	var _reversed: Bool

	var curve1: FBBezierCurve {
		return self._curve1
	}

	var parameterRange1: FBRange {
		return self._parameterRange1
	}

	var curve2: FBBezierCurve {
		return self._curve2
	}

	var parameterRange2: FBRange {
		return self._parameterRange2
	}

	var reversed: Bool {
		return self._reversed
	}

	// + (id) intersectRangeWithCurve1:(FBBezierCurve *)curve1 parameterRange1:(FBRange)parameterRange1 curve2:(FBBezierCurve *)curve2 parameterRange2:(FBRange)parameterRange2 reversed:(BOOL)reversed;
	// let i = FBBezierIntersectRange(curve1: dvbc1, parameterRange1: pr1, curve2: dvbc2, parameterRange2: pr2, reversed: rvsd)
	init(curve1: FBBezierCurve, parameterRange1: FBRange, curve2: FBBezierCurve, parameterRange2: FBRange, reversed: Bool) {
		self._curve1 = curve1
		self._parameterRange1 = parameterRange1
		self._curve2 = curve2
		self._parameterRange2 = parameterRange2
		self._reversed = reversed
	}

	// - (FBBezierCurve *) curve1LeftBezier
	var curve1LeftBezier: FBBezierCurve {
		self.computeCurve1()
		return self._curve1LeftBezier!
	}

	// - (FBBezierCurve *) curve1OverlappingBezier
	var curve1OverlappingBezier: FBBezierCurve {
		self.computeCurve1()
		return self._curve1MiddleBezier!
	}

	// - (FBBezierCurve *) curve1RightBezier
	var curve1RightBezier: FBBezierCurve {
		self.computeCurve1()
		return self._curve1RightBezier!
	}

	// - (FBBezierCurve *) curve2LeftBezier
	var curve2LeftBezier: FBBezierCurve {
		self.computeCurve2()
		return self._curve2LeftBezier!
	}

	// - (FBBezierCurve *) curve2OverlappingBezier
	var curve2OverlappingBezier: FBBezierCurve {
		self.computeCurve2()
		return self._curve2MiddleBezier!
	}

	// - (FBBezierCurve *) curve2RightBezier
	var curve2RightBezier: FBBezierCurve {
		self.computeCurve2()
		return self._curve2RightBezier!
	}

	// - (BOOL) isAtStartOfCurve1
	var isAtStartOfCurve1: Bool {
		return FBAreValuesCloseWithOptions(self._parameterRange1.minimum, value2: 0.0, threshold: FBParameterCloseThreshold)
	}

	// - (BOOL) isAtStopOfCurve1
	var isAtStopOfCurve1: Bool {
		return FBAreValuesCloseWithOptions(self._parameterRange1.maximum, value2: 1.0, threshold: FBParameterCloseThreshold)
	}

	// - (BOOL) isAtStartOfCurve2
	var isAtStartOfCurve2: Bool {
		return FBAreValuesCloseWithOptions(self._parameterRange2.minimum, value2: 0.0, threshold: FBParameterCloseThreshold)
	}

	// - (BOOL) isAtStopOfCurve2
	var isAtStopOfCurve2: Bool {
		return FBAreValuesCloseWithOptions(self._parameterRange2.maximum, value2: 1.0, threshold: FBParameterCloseThreshold)
	}

	// - (FBBezierIntersection *) middleIntersection
	var middleIntersection: FBBezierIntersection {
		return FBBezierIntersection(
			curve1: self._curve1,
			param1: (self._parameterRange1.minimum + self._parameterRange1.maximum) / 2.0,
			curve2: self._curve2,
			param2: (self._parameterRange2.minimum + self._parameterRange2.maximum) / 2.0)
	}

	func merge(_ other: FBBezierIntersectRange) {
		// We assume the caller already knows we're talking about the same curves
		self._parameterRange1 = FBRangeUnion(self._parameterRange1, range2: other._parameterRange1)
		self._parameterRange2 = FBRangeUnion(self._parameterRange2, range2: other._parameterRange2)

		self.clearCache()
	}

	private func clearCache() {
		self.needToComputeCurve1 = true
		self.needToComputeCurve2 = true

		self._curve1LeftBezier = nil
		self._curve1MiddleBezier = nil
		self._curve1RightBezier = nil
		self._curve2LeftBezier = nil
		self._curve2MiddleBezier = nil
		self._curve2RightBezier = nil
	}

	// - (void) computeCurve1
	private func computeCurve1() {
		if self.needToComputeCurve1 {
			let swr = self._curve1.splitSubcurvesWithRange(self._parameterRange1, left: true, middle: true, right: true)
			self._curve1LeftBezier = swr.left
			self._curve1MiddleBezier = swr.mid
			self._curve1RightBezier = swr.right

			self.needToComputeCurve1 = false
		}
	}

	// 114
	// - (void) computeCurve2
	private func computeCurve2() {
		if self.needToComputeCurve2 {
			let swr = self._curve2.splitSubcurvesWithRange(self._parameterRange2, left: true, middle: true, right: true)
			self._curve2LeftBezier = swr.left
			self._curve2MiddleBezier = swr.mid
			self._curve2RightBezier = swr.right

			self.needToComputeCurve2 = false
		}
	}
}
