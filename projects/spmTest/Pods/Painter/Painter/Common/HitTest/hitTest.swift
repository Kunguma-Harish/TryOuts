//
//  hitTest.swift
//  Painter
//
//  Created by Jaganraj Palanivel on 05/03/18.
//  Copyright © 2018 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

public class ReachableShapeObject {
	public var shapeIDs: [String] = []
	public var type: ShapeNodeType
	public var object: Any

	public init(type: ShapeNodeType, id: String, object: Any) {
		self.object = object
		self.type = type
		self.shapeIDs = [id]
	}

	public func addParent(id: String) {
		self.shapeIDs.append(id)
	}

	public func hasParent() -> Bool {
		return self.shapeIDs.count > 1 ? true : false
	}
}

public extension Array where Element == ReachableShapeObject {
	func getShapeObjects() -> [ShapeObject] {
		var shapeObjects: [ShapeObject] = []
		for reachableShapeObject in self where reachableShapeObject.type != .connector {
			var so = ShapeObject()
			so.type = reachableShapeObject.type

			switch reachableShapeObject.type {
			case .shape:
				so.shape = (reachableShapeObject.object as? Shape) ?? Shape()
			case .picture:
				so.picture = (reachableShapeObject.object as? Proto.Picture) ?? Picture()
			case .connector:
				so.connector = (reachableShapeObject.object as? Connector) ?? Connector()
			case .groupshape:
				so.groupshape = (reachableShapeObject.object as? ShapeObject.GroupShape) ?? ShapeObject.GroupShape()
			case .graphicframe:
				so.graphicframe = (reachableShapeObject.object as? GraphicFrame) ?? GraphicFrame()
			case .paragraph:
				so.paragraph = (reachableShapeObject.object as? ShapeObject.ParagraphShape) ?? ShapeObject.ParagraphShape()
			case .combinedobject:
				so.combinedobject = (reachableShapeObject.object as? ShapeObject.CombinedObject) ?? ShapeObject.CombinedObject()
			}
			shapeObjects.append(so)
		}
		return shapeObjects
	}
}

public extension ShapeObject {
	func contains(point: CGPoint, groupTransform gtrans: Transform? = nil, using config: PainterConfig?) -> ReachableShapeObject? {
		switch self.type {
		case .shape:
			return shapeHitTest(point: point, gtrans: gtrans, using: config)
		case .picture:
			return pictureHitTest(point: point, gtrans: gtrans, using: config)
		case .connector:
			return connectorHitTest(point: point, gtrans: gtrans, using: config)
		case .groupshape:
			return groupshapeHitTest(point: point, gtrans: gtrans, using: config)
		case .graphicframe:
			return invalidHitTest(point: point, gtrans: gtrans)
		case .paragraph:
			return invalidHitTest(point: point, gtrans: gtrans)
		case .combinedobject:
			return combinedobjectHitTest(point: point, gtrans: gtrans, using: config)
		}
	}
}

private extension ShapeObject {
	func shapeHitTest(point: CGPoint, gtrans: Transform? = nil, using config: PainterConfig?) -> ReachableShapeObject? {
		if let shapeId = self.shape.contains(point: point, groupTransform: gtrans, using: config) {
			let rshape = ReachableShapeObject(type: .shape, id: shapeId, object: self)
			return rshape
		}
		return nil
	}

	func pictureHitTest(point: CGPoint, gtrans: Transform? = nil, using config: PainterConfig?) -> ReachableShapeObject? {
		if let shapeId = self.picture.contains(point: point, groupTransform: gtrans, using: config) {
			let rshape = ReachableShapeObject(type: .picture, id: shapeId, object: self)
			return rshape
		}
		return nil
	}

	func groupshapeHitTest(point: CGPoint, gtrans: Transform? = nil, using config: PainterConfig?) -> ReachableShapeObject? {
		if let rshape = self.groupshape.contains(point: point, groupTransform: gtrans, using: config) {
			return rshape
		}
		return nil
	}

	func combinedobjectHitTest(point: CGPoint, gtrans: Transform? = nil, using config: PainterConfig?) -> ReachableShapeObject? {
		if let rshape = self.combinedobject.contains(point: point, groupTransform: gtrans, using: config) {
			return rshape
		}
		return nil
	}

	func connectorHitTest(point: CGPoint, gtrans: Transform? = nil, using config: PainterConfig?) -> ReachableShapeObject? {
		if let shapeId = self.connector.contains(point: point, groupTransform: gtrans, using: config) {
			let rshape = ReachableShapeObject(type: .connector, id: shapeId, object: self)
			return rshape
		}
		return nil
	}

	func invalidHitTest(point: CGPoint, gtrans: Transform? = nil) -> ReachableShapeObject? {
		// TODO: implement hit test for the bbelow objects
		assertionFailure("connector, paragraph and graphicframe hitTests not yet implemeted")
		return nil
	}
}

public extension Shape {
	func contains(point: CGPoint, groupTransform gtrans: Transform? = nil, using config: PainterConfig?) -> String? {
		if hasTextBody {
			// TODO: - has to be handled by sarath.g@zohocorp.com
			let mtrans = props.transform.getModifiedTransform(group: gtrans, using: config)
			let point = point.rotate(
				around: mtrans.rect.center,
				byDegree: CGFloat(-mtrans.rotationAngle))
			if mtrans.rect.contains(point) {
				return self.nvOprops.nvDprops.id
			}
		}
		if props.contains(point: point, groupTransform: gtrans, id: self.nvOprops.nvDprops.id, using: config) {
			return self.nvOprops.nvDprops.id
		}
		return nil
	}
}

public extension Proto.Picture {
	func contains(point: CGPoint, groupTransform gtrans: Transform? = nil, using config: PainterConfig?) -> String? {
		let mtrans = props.transform.getModifiedTransform(group: gtrans, using: config)
		let point = point.rotate(
			around: mtrans.rect.center,
			byDegree: CGFloat(-mtrans.rotationAngle))
		if mtrans.rect.contains(point) {
			return self.nvOprops.nvDprops.id
		}
		return nil
	}
}

public extension ShapeObject.GroupShape {
	func contains(point: CGPoint, groupTransform gtrans: Transform? = nil, using config: PainterConfig?) -> ReachableShapeObject? {
		let mtrans = props.transform.getModifiedTransform(group: gtrans, using: config)
		let point = point.rotate(
			around: mtrans.rect.center,
			byDegree: CGFloat(-mtrans.rotationAngle))
		if mtrans.rect.contains(point) {
			for shape in self.shapes.reversed() {
				if let rshape = shape.contains(point: point, groupTransform: mtrans, using: config) {
					rshape.addParent(id: self.nvOprops.nvDprops.id)
					return rshape
				}
			}
		}
		return nil
	}
}

public extension ShapeObject.CombinedObject {
	func contains(point: CGPoint, groupTransform gtrans: Transform? = nil, using config: PainterConfig?) -> ReachableShapeObject? {
		let mtrans = props.transform.getModifiedTransform(group: gtrans, using: config)
		if props.contains(point: point, groupTransform: gtrans, id: self.nvOprops.nvDprops.id, using: config) {
			for node in combinedNodes.reversed() {
				switch node.type {
				case .unknown:
					assertionFailure("Should not come here.")
					return nil
				case .shape:
					if let shapeId = node.shape.contains(point: point, groupTransform: mtrans, using: config) {
						let rshape = ReachableShapeObject(type: .shape, id: shapeId, object: node.shape)
						rshape.addParent(id: self.nvOprops.nvDprops.id)
						return rshape
					}
				case .combinedobject:
					if let rshape = node.combinedobject.contains(point: point, groupTransform: mtrans, using: config) {
						rshape.addParent(id: self.nvOprops.nvDprops.id)
						return rshape
					}
				}
			}
		}
		return nil
	}
}

public extension Connector {
	func contains(point: CGPoint, groupTransform gtrans: Transform? = nil, using config: PainterConfig?) -> String? {
		// set minimum stroke width to 3 so that lines with thickness less than 3 can be selected
		var newProps = self.props
		if newProps.hasStroke {
			if newProps.stroke.width < 3 {
				newProps.stroke.width = 3
			}
		}
		for i in 0..<newProps.strokes.count where newProps.strokes[i].width < 3 {
			newProps.strokes[i].width = 3
		}
		if newProps.contains(point: point, groupTransform: gtrans, id: self.nvOprops.nvDprops.id, using: config) {
			return self.nvOprops.nvDprops.id
		}
		return nil
	}
}

public extension Properties {
	func contains(point: CGPoint, groupTransform gtrans: Transform? = nil, id: String, using config: PainterConfig?) -> Bool {
		var mtrans = transform.getModifiedTransform(group: gtrans, using: config)
		var contains = false

		if let gtrans = gtrans {
			if gtrans.flipv {
				let p = gtrans.flipv
				let q = mtrans.flipv
				// Logical xor
				mtrans.flipv = (p || q) && !(p && q)
				mtrans.pos.top = gtrans.pos.top + ((gtrans.pos.top + gtrans.dim.height) - (mtrans.pos.top + mtrans.dim.height))
			}
			if gtrans.fliph {
				let p = gtrans.fliph
				let q = mtrans.fliph
				// Logical xor
				mtrans.fliph = (p || q) && !(p && q)
				// translating the child shape's position
				mtrans.pos.left = gtrans.pos.left + ((gtrans.pos.left + gtrans.dim.width) - (mtrans.pos.left + mtrans.dim.width))
			}
		}
		let path = transformedCGPath(forTransform: mtrans, id: id, using: config)

		if hasFill || !fills.isEmpty {
			contains = path.contains(point, using: .evenOdd)
		}

		if hasStroke || !strokes.isEmpty {
			for stroke in strokes where stroke.getStrokeFillPath(for: path, with: id, config: config).contains(point) {
				contains = true
			}
			if hasStroke, stroke.contains(point: point, for: path) {
				contains = true
			}
		}

		if hasEffects {
			if effects.hasShadow || !effects.shadows.isEmpty {
				// TODO: - shadow hitTest has to be implemented
				// assert(false, "shadow hitTest has to be implemented")
			}
		}
		return contains
	}
}
