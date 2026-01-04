//
//  CustomGeometry+AffineTransform.swift
//  Painter
//
//  Created by Sarath Kumar G on 26/02/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

public extension CustomGeometry {
	var patternCgPath: CGPath {
		if pathList.isEmpty {
			assertionFailure("empty customgeometry")
			return CGMutablePath()
		}
		return pathList.patternCgpaths.cgpath
	}

	func applying(_ t: CGAffineTransform) -> CustomGeometry {
		if pathList.isEmpty {
			return CustomGeometry()
		}
		var finalPathObject = self.pathList
		for i in 0..<self.pathList.count {
			var pathObjects = self.pathList[i].path
			for i in 0..<pathObjects.count {
				switch pathObjects[i].type {
				case .m:
					let radius = pathObjects[i].m.radius
					pathObjects[i].m = pathObjects[i].m.cgPoint.applying(t).point
					if !pathObjects[i].cc.isEmpty {
						pathObjects[i].cc[0] = pathObjects[i].cc[0].cgPoint.applying(t).point
					}
					pathObjects[i].m.radius = radius
				case .l:
					let radius = pathObjects[i].l.radius
					pathObjects[i].l = pathObjects[i].l.cgPoint.applying(t).point
					pathObjects[i].l.radius = radius
				case .cc:
					guard pathObjects[i].cc.count == 3 else {
						continue
					}
					let radius = pathObjects[i].cc[2].radius
					pathObjects[i].cc[0] = pathObjects[i].cc[0].cgPoint.applying(t).point
					pathObjects[i].cc[1] = pathObjects[i].cc[1].cgPoint.applying(t).point
					pathObjects[i].cc[2] = pathObjects[i].cc[2].cgPoint.applying(t).point
					pathObjects[i].cc[2].radius = radius
				case .qc:
					guard !pathObjects[i].qc.isEmpty else {
						continue
					}
					pathObjects[i].qc[0] = pathObjects[i].qc[0].cgPoint.applying(t).point
					if pathObjects[i].qc.count == 2 {
						let radius = pathObjects[i].qc[1].radius
						pathObjects[i].qc[1] = pathObjects[i].qc[1].cgPoint.applying(t).point
						pathObjects[i].qc[1].radius = radius
					}
				case .c:
					break
				case .ea:
					break
				case .scc:
					guard pathObjects[i].scc.count == 2 else {
						continue
					}
					let radius = pathObjects[i].scc[1].radius
					pathObjects[i].scc[0] = pathObjects[i].scc[0].cgPoint.applying(t).point
					pathObjects[i].scc[1] = pathObjects[i].scc[1].cgPoint.applying(t).point
					pathObjects[i].scc[1].radius = radius
				case .sqc:
					guard !pathObjects[i].sqc.isEmpty else {
						continue
					}
					let radius = pathObjects[i].sqc[0].radius
					pathObjects[i].sqc[0] = pathObjects[i].sqc[0].cgPoint.applying(t).point
					pathObjects[i].sqc[0].radius = radius
				}
			}
			finalPathObject[i].path = pathObjects
		}
		return CustomGeometry.with {
			$0.pathList = finalPathObject
		}
		//        return CustomGeometry.with {
		//            $0.pathList.append(CustomGeometry.Path.with {
		//                $0.path = pathObjects
		//            })
		//        }
	}
}

extension CustomGeometry.Path {
	var patternCgPath: CGPath {
		let cgpath = CGMutablePath()
		for node in path {
			switch node.type {
			case .m:
				cgpath.move(to: node.m.cgPoint(width: width, height: height))
			case .l:
				cgpath.addLine(to: node.l.cgPoint(width: width, height: height))
			case .cc:
				cgpath.addCurve(
					to: node.cc[2].cgPoint(width: width, height: height),
					control1: node.cc[0].cgPoint(width: width, height: height),
					control2: node.cc[1].cgPoint(width: width, height: height))
			case .qc:
				cgpath.addQuadCurve(
					to: node.qc[1].cgPoint(width: width, height: height),
					control: node.qc[0].cgPoint(width: width, height: height))
			case .ea:
				assertionFailure("ea not yet implemented")
			case .scc:
				assertionFailure("scc not yet implemented")
			case .sqc:
				assertionFailure("sqc not yet implemented")
			case .c:
				cgpath.closeSubpath()
			}
		}
		return cgpath
	}
}

public extension PathObject.Point {
	var cgPoint: CGPoint {
		return CGPoint(x, y)
	}

	func cgPoint(width: Float, height: Float) -> CGPoint {
		return CGPoint(x / width, y / height)
	}
}
