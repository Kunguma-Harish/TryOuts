//
//  Preset+GroupShape.swift
//  Painter
//
//  Created by Sarath Kumar G on 03/04/18.
//  Copyright © 2018 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

public extension ShapeObject {
	var isPeopleIndicator: Bool {
		if type == .groupshape, self.groupshape.isSmartGroupShape, self.groupshape.nvOprops.nvDprops.name == "PEOPLE_INDICATOR" {
			return true
		}
		return false
	}

	var isMultiPathCropShape: Bool {
		return (hasType && type == .picture && hasPicture) ? picture.isMultiPathCropShape : false
	}

	var isSmartObjPreset: Bool {
		return (hasType && type == .shape && hasShape) ? shape.isSmartPreset : false
	}
}

extension ShapeObject {
	static var custom: ShapeObject {
		return ShapeObject.with {
			$0.type = .shape
			$0.shape.nvOprops.nvDprops.id = UUID().uuidString
			$0.shape.props.geom.type = .custom
		}
	}

	static var groupShape: ShapeObject {
		return ShapeObject.with {
			$0.type = .groupshape
			$0.groupshape.nvOprops.nvDprops.id = UUID().uuidString
		}
	}

	static var multipathChildShape: ShapeObject {
		return ShapeObject.with {
			$0.type = .shape
			$0.shape.nvOprops.nvDprops.id = UUID().uuidString
			$0.shape.props.geom.type = .custom
			$0.shape.props.fill.type = .grp
			$0.shape.props.fill.grp = true
		}
	}

	static var multipathGfillChildShape: ShapeObject {
		return ShapeObject.with {
			$0.type = .shape
			$0.shape.nvOprops.nvDprops.id = UUID().uuidString
			$0.shape.props.geom.type = .custom
		}
	}
}

extension Proto.Picture {
	var isMultiPathCropShape: Bool {
		return self.hasProps &&
			self.props.hasGeom &&
			self.props.geom.type == .preset && PainterConfig.multiPathPresets.contains(self.props.geom.preset.type)
	}
}

extension Shape {
	var isSmartPreset: Bool {
		return self.hasProps &&
			self.props.hasGeom &&
			self.props.geom.type == .preset &&
			PainterConfig.smartPresets.contains(self.props.geom.preset.type)
	}

	var isTextPresetShape: Bool {
		return self.hasProps &&
			self.props.hasGeom &&
			self.props.geom.type == .preset &&
			PainterConfig.textPresets.contains(self.props.geom.preset.type)
	}

	func drawMultiPathPreset(
		in ctx: RenderingContext,
		withGroupProps gprops: Properties?,
		config: PainterConfig? = nil,
		matrix: OrientationMatrices,
		shapeOrientation: ShapeOrientation,
		crop: Offset? = nil) {
		self.props.getMultiPathGroupShape(gprops: gprops).draw(
			in: ctx,
			withGroupProps: gprops,
			using: config,
			matrix: matrix,
			shapeOrientation: shapeOrientation,
			crop: crop,
			isMultiPathPreset: true)

		if ctx.editingTextID != self.nvOprops.nvDprops.id,
		   !self.textBody.isEmpty(id: self.nvOprops.nvDprops.id, using: config) {
			self.drawTextBody(in: ctx, withGroupProps: gprops, using: config, matrix: matrix)
		}
	}
}

public extension Properties {
	var isMultiPathPreset: Bool {
		return self.hasGeom &&
			self.geom.hasType &&
			self.geom.type == .preset &&
			self.geom.hasPreset &&
			PainterConfig.multiPathPresets.contains(self.geom.preset.type)
	}

	func cropPath(forId shapeId: String, using config: PainterConfig?) -> CGPath {
		let cropPath = CGMutablePath()
		if self.isMultiPathPreset {
			let presetPathList = geom.preset.pathList
			let transRect = transform.rect
			let pathInfo = geom.preset.pathInfo(frame: transRect)
			for (pathIndex, path) in pathInfo.paths.enumerated() where
				pathIndex < presetPathList.count &&
				presetPathList[pathIndex].hasFill &&
				presetPathList[pathIndex].fill.hasFill &&
				presetPathList[pathIndex].fill.fill != .none {
				cropPath.addPath(path)
			}
		} else {
			cropPath.addPath(self.transformedCGPath(id: shapeId, using: config))
		}
		return cropPath
	}

	func getMultiPathGroupShape(gprops: Properties?) -> ShapeObject {
		var parentGroupShape = ShapeObject()
		parentGroupShape.type = .groupshape
		parentGroupShape.groupshape.nvOprops.nvDprops.id = UUID().uuidString

		let transRect = transform.rect
		parentGroupShape.groupshape.props.transform = transform
		parentGroupShape.groupshape.props.transform.chRect = transRect

		if self.hasEffects {
			parentGroupShape.groupshape.props.effects = effects // required to draw shadows
		}

		parentGroupShape.groupshape.props.anim = anim
		parentGroupShape.groupshape.props.animData = animData

		let presetPathList = geom.preset.pathList
		let pathInfo = geom.preset.pathInfo(frame: transRect)

		for (pathIndex, path) in pathInfo.paths.enumerated() {
			let defPathIndex = (pathIndex < pathInfo.pathProps.count) ? pathInfo.pathProps[pathIndex] - 1 : pathIndex

			var childShape = self.fill.type == .grp ? ShapeObject.multipathGfillChildShape : ShapeObject.multipathChildShape
			childShape.shape.props.geom.custom = path.custom
			childShape.shape.props.transform.rect = path.boundingBoxOfPath

			var childGroupShape = ShapeObject.groupShape
			childGroupShape.groupshape.props.transform.rect = transRect
			childGroupShape.groupshape.props.transform.chRect = transRect

			var childShapeProps = childShape.props
			var childGroupShapeProps = childGroupShape.props

			if presetPathList.count > defPathIndex {
				if self.fill.type == .grp {
					setMultiPathFill(to: &childShapeProps, from: presetPathList[defPathIndex], gprops: gprops)
				} else {
					setMultiPathFill(to: &childGroupShapeProps, from: presetPathList[defPathIndex], gprops: nil)
				}
				setStroke(to: &childShapeProps, from: presetPathList[defPathIndex])
			} else {
				if self.hasFill {
					childGroupShapeProps.fill = self.fill
				}
				childGroupShapeProps.fills = self.fills

				if self.hasStroke {
					childShapeProps.stroke = self.stroke
				}
				childShapeProps.strokes = self.strokes
			}

			childShape.props = childShapeProps
			childGroupShape.props = childGroupShapeProps

			childGroupShape.groupshape.shapes.append(childShape)
			parentGroupShape.groupshape.shapes.append(childGroupShape)
		}
		return parentGroupShape
	}
}

private extension Properties {
	func setMultiPathFill(to props: inout Properties, from pathInfo: PresetShape.PathList, gprops: Properties?) {
		if !pathInfo.hasFill || (pathInfo.hasFill && pathInfo.fill.fill == .normal) {
			if hasFill {
				if let gprops = gprops {
					props.fill = gprops.fill
				} else {
					props.fill = fill
				}
				if pathInfo.fill.hasTweaks {
					if props.fill.hasSolid {
						props.fill.solid.color.applyTweaks(pathInfo.fill.tweaks)
					}
					if props.fill.hasGradient {
						for i in 0..<props.fill.gradient.stops.count {
							props.fill.gradient.stops[i].color
								.applyTweaks(pathInfo.fill.tweaks)
						}
					}
				}
			} else if !fills.isEmpty {
				for index in 0..<fills.count {
					props.fills.append(fills[index])
					if pathInfo.fill.hasTweaks {
						props.fills[index].solid.color
							.applyTweaks(pathInfo.fill.tweaks)
					}
				}
			}
		}
	}

	func setStroke(to props: inout Properties, from pathInfo: PresetShape.PathList) {
		if !pathInfo.hasStroke || (pathInfo.hasStroke && pathInfo.stroke.fill == .normal) {
			if hasStroke {
				props.stroke = stroke
				if pathInfo.stroke.hasTweaks {
					props.stroke.fill.solid.color.applyTweaks(pathInfo.stroke.tweaks)
				}
			} else if !strokes.isEmpty {
				for index in 0..<strokes.count {
					props.strokes.append(strokes[index])
					if pathInfo.stroke.hasTweaks {
						props.strokes[index].fill.solid.color
							.applyTweaks(pathInfo.stroke.tweaks)
					}
				}
			}
		}
	}
}
