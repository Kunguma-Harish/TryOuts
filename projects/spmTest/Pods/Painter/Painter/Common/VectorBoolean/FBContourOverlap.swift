//
//  FBContourOverlap.swift
//  Swift VectorBoolean for iOS
//
//  Based on FBContourOverlap - Created by Andrew Finnell on 11/7/12.
//  Copyright (c) 2012 Fortunate Bear, LLC. All rights reserved.
//
//  Created by Leslie Titze on 2015-07-02.
//  Copyright (c) 2015 Leslie Titze. All rights reserved.
//

import CoreGraphics
import Foundation

class FBContourOverlap {
	private var runs: [FBEdgeOverlapRun] = []

	/* ======== THESE ARE PUBLIC ===========
	 - (void) addOverlap:(FBBezierIntersectRange *)range forEdge1:(FBBezierCurve *)edge1 edge2:(FBBezierCurve *)edge2;
	 - (void) runsWithBlock:(void (^)(FBEdgeOverlapRun *run, BOOL *stop))block;

	 - (void) reset;

	 - (BOOL) isComplete;
	 - (BOOL) isEmpty;

	 - (BOOL) isBetweenContour:(FBBezierContour *)contour1 andContour:(FBBezierContour *)contour2;
	 - (BOOL) doesContainCrossing:(FBEdgeCrossing *)crossing;
	 - (BOOL) doesContainParameter:(CGFloat)parameter onEdge:(FBBezierCurve *)edge;
	 ============= END PUBLIC ============== */

	// + (id) contourOverlap
	// Use t = FBContourOverlap() instead

	// - (void) addOverlap:(FBBezierIntersectRange *)range forEdge1:(FBBezierCurve *)edge1 edge2:(FBBezierCurve *)edge2
	func addOverlap(_ range: FBBezierIntersectRange, forEdge1 edge1: FBBezierCurve, edge2: FBBezierCurve) {
		let overlap = FBEdgeOverlap(range: range, edge1: edge1, edge2: edge2)

		var createNewRun = false

		if self.runs.isEmpty {
			createNewRun = true
		} else if self.runs.count == 1 {
			let inserted = self.runs.last!.insertOverlap(overlap)
			createNewRun = !inserted
		} else {
			var inserted = self.runs.last!.insertOverlap(overlap)
			if !inserted {
				inserted = self.runs[0].insertOverlap(overlap)
			}
			createNewRun = !inserted
		}

		if createNewRun {
			let run = FBEdgeOverlapRun()
			run.insertOverlap(overlap)
			self.runs.append(run)
		}
	}

	// - (BOOL) doesContainCrossing:(FBEdgeCrossing *)crossing
	func doesContainCrossing(_ crossing: FBEdgeCrossing) -> Bool {
		if self.runs.isEmpty {
			return false
		}

		for run in self.runs {
			if run.doesContainCrossing(crossing) {
				return true
			}
		}

		return false
	}

	// - (BOOL) doesContainParameter:(CGFloat)parameter onEdge:(FBBezierCurve *)edge
	func doesContainParameter(_ parameter: Double, onEdge edge: FBBezierCurve) -> Bool {
		if self.runs.isEmpty {
			return false
		}

		for run in self.runs {
			if run.doesContainParameter(parameter, onEdge: edge) {
				return true
			}
		}

		return false
	}

	// - (void) runsWithBlock:(void (^)(FBEdgeOverlapRun *run, BOOL *stop))block
	func runsWithBlock(_ block: (_ run: FBEdgeOverlapRun) -> Bool) {
		if self.runs.isEmpty {
			return
		}

		for run in self.runs {
			let stop = block(run)
			if stop {
				break
			}
		}
	}

	// - (void) reset
	func reset() {
		if self.runs.isEmpty {
			return
		}
		self.runs.removeAll()
	}

	// - (BOOL) isComplete
	var isComplete: Bool {
		if self.runs.isEmpty {
			return false
		}

		// To be complete, we should have exactly one run that wraps around
		if self.runs.count != 1 {
			return false
		}

		return self.runs[0].isComplete
	}

	// - (BOOL) isEmpty
	var isEmpty: Bool {
		return self.runs.isEmpty
	}

	// @property (readonly) FBBezierContour *contour1;
	// - (FBBezierContour *) contour1
	var contour1: FBBezierContour? {
		if self.runs.isEmpty {
			return nil
		}

		let run = self.runs[0]
		return run.contour1
	}

	// @property (readonly) FBBezierContour *contour2;
	// - (FBBezierContour *) contour2
	var contour2: FBBezierContour? {
		if self.runs.isEmpty {
			return nil
		}

		let run = self.runs[0]
		return run.contour2
	}

	// - (BOOL) isBetweenContour:(FBBezierContour *)contour1 andContour:(FBBezierContour *)contour2
	func isBetweenContour(_ contour1: FBBezierContour, andContour contour2: FBBezierContour) -> Bool {
		let myContour1 = self.contour1
		let myContour2 = self.contour2

		return (contour1 === myContour1 && contour2 === myContour2) || (contour1 === myContour2 && contour2 === myContour1)
	}
}
