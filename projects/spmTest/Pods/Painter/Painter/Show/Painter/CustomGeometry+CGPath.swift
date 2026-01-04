//
//  CustomGeometry+CGPath.swift
//  Painter
//
//  Created by Sarath Kumar G on 26/02/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

public extension Array where Element == CustomGeometry {
	var cgpath: CGPath {
		let path = CGMutablePath()
		forEach { path.addPath($0.cgpath) }
		return path
	}
}

public extension CustomGeometry {
	var cgpath: CGPath {
		if pathList.isEmpty {
			assertionFailure("empty customgeometry")
			return CGMutablePath()
		}
		return pathList.cgpaths.cgpath
	}
}

extension CustomGeometry.Path {
	var cgpath: CGPath {
		let cgpath = CGMutablePath()
		for node in path {
			switch node.type {
			case .m:
				cgpath.move(to: node.m.cgPoint)
			case .l:
				cgpath.addLine(to: node.l.cgPoint)
			case .cc:
				cgpath.addCurve(to: node.cc[2].cgPoint, control1: node.cc[0].cgPoint, control2: node.cc[1].cgPoint)
			case .qc:
				cgpath.addQuadCurve(to: node.qc[1].cgPoint, control: node.qc[0].cgPoint)
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
