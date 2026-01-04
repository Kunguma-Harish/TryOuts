//
//  CombinedObject+Draw.swift
//  Painter
//
//  Created by Jaganraj Palanivel on 20/11/17.
//  Copyright © 2017 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

public extension ShapeObject.CombinedObject {
	var frame: CGRect {
		get {
			return props.transform.rect
		}
		set {
			props.transform.rect = newValue
		}
	}

	func booleanProps(using config: PainterConfig?) -> Properties {
		var cshape = self
		cshape.props = Properties()
		cshape.nvOprops = NonVisualCombinedShapeProps()

		if let cprops = config?.cache?.getCombinedShapeToPropsMap(for: cshape.hashValue) {
			return cprops
		} else {
			var combinedShapeRawPath: CGPath
			if let path = config?.cache?.getCombinedShapeToPathMap(for: cshape.hashValue) {
				combinedShapeRawPath = path
			} else {
				switch combinedNodes[0].type {
				case .unknown:
					assertionFailure("Should not come here.")
					return Properties()
				case .shape:
					combinedShapeRawPath = combinedNodes[0].shape.props.transformedCGPath(id: combinedNodes[0].shape.nvOprops.nvDprops.id, using: config)
				case .combinedobject:
					combinedShapeRawPath = combinedNodes[0].combinedobject.props.transformedCGPath(id: combinedNodes[0].shape.nvOprops.nvDprops.id, using: config)
				}

				for i in 1..<combinedNodes.count {
					let nextPath: CGPath
					switch combinedNodes[i].type {
					case .unknown:
						assertionFailure("Should not come here.")
						continue
					case .shape:
						nextPath = combinedNodes[i].shape.props.transformedCGPath(id: combinedNodes[i].shape.nvOprops.nvDprops.id, using: config)
					case .combinedobject:
						nextPath = combinedNodes[i].combinedobject.props.transformedCGPath(id: combinedNodes[i].shape.nvOprops.nvDprops.id, using: config)
					}

					switch combinedNodes[i].rule {
					case .noRule, .union, .combine:
						combinedShapeRawPath = combinedShapeRawPath.fb_union(nextPath)
					case .intersect:
						combinedShapeRawPath = combinedShapeRawPath.fb_intersect(nextPath)
					case .subtract:
						combinedShapeRawPath = combinedShapeRawPath.fb_difference(nextPath)
					case .inverseIntersect:
						combinedShapeRawPath = combinedShapeRawPath.fb_xor(nextPath)
					}
				}
			}
			config?.cache?.setCombinedShapeToPathMap(for: cshape.hashValue, value: combinedShapeRawPath)
			var cprops = self.props
			cprops.geom.type = .custom
			cprops.geom.custom = combinedShapeRawPath.custom
			config?.cache?.setRawGeomPathMap(for: self.nvOprops.nvDprops.id, value: combinedShapeRawPath)

			config?.cache?.setCombinedShapeToPropsMap(for: cshape.hashValue, value: cprops)
			return cprops
		}
	}

	func draw(
		in ctx: RenderingContext,
		withGroupProps gprops: Properties?,
		using config: PainterConfig?,
		matrix: OrientationMatrices,
		shouldDrawShadowAsImage: Bool = true) {
		if true || !combinedNodes.areAllRulesNoRule {
			props.draw(
				in: ctx,
				withGroupProps: gprops,
				using: config,
				forId: self.nvOprops.nvDprops.id,
				matrix: matrix,
				shouldDrawShadowAsImage: shouldDrawShadowAsImage)
			//            booleanProps.draw(inContext: ctx, GroupTransformer: gtrans)
		} else {
			let mprops = props.getModifiedProps(from: gprops, using: config)
			let currentMatrices = self.props.transform.getMatrix(matrix, gTrans: gprops?.transform)
			for node in combinedNodes {
				switch node.type {
				case .unknown:
					assertionFailure("Should not come here.")
					continue
				case .shape:
					node.shape.draw(
						in: ctx,
						withGroupProps: mprops,
						matrix: currentMatrices,
						shouldDrawShadowAsImage: shouldDrawShadowAsImage)
				case .combinedobject:
					node.combinedobject.draw(
						in: ctx,
						withGroupProps: mprops,
						using: config,
						matrix: currentMatrices)
				}
			}
		}
	}

	func drawableContentFrame(config: PainterConfig?, matrix: OrientationMatrices = .identity, gprops: Properties? = nil) -> CGRect {
		return refreshFrame(parentId: nil, config: config, shouldCache: false, matrix: matrix, gprops: gprops)
	}
}

public extension ShapeObject.CombinedObject.CombinedNode {
	var props: Properties {
		get {
			switch self.type {
			case .shape:
				return self.shape.props
			case .combinedobject:
				return self.combinedobject.props
			case .unknown:
				assertionFailure()
				return Properties()
			}
		}
		set {
			switch self.type {
			case .shape:
				self.shape.props = newValue
			case .combinedobject:
				self.combinedobject.props = newValue
			case .unknown:
				assertionFailure()
			}
		}
	}

	var trans: Transform {
		get {
			return self.props.transform
		}
		set {
			self.props.transform = newValue
		}
	}

	var shapeObject: ShapeObject {
		switch self.type {
		case .shape:
			return ShapeObject.with {
				$0.type = .shape
				$0.shape = self.shape
			}
		case .combinedobject:
			return ShapeObject.with {
				$0.type = .combinedobject
				$0.combinedobject = self.combinedobject
			}
		case .unknown:
			assertionFailure()
			return ShapeObject()
		}
	}
}

public extension Array where Element == ShapeObject.CombinedObject.CombinedNode {
	var areAllRulesNoRule: Bool {
		for node in self where node.rule != .noRule {
			return false
		}
		return true
	}
}
