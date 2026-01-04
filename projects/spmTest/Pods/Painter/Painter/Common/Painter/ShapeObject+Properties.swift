//
//  ShapeObject+Properties.swift
//  Painter
//
//  Created by Sarath Kumar G on 25/02/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

public extension ShapeObject {
	var isMultiPathPreset: Bool {
		return (hasType && type == .shape && hasShape) ? shape.isMultiPathPreset : false
	}

	var isPictureCroppedToMultiPathShape: Bool {
		return (hasType && type == .picture && hasPicture) ? PainterConfig.multiPathPresets.contains(picture.props.geom.preset.type) : false
	}

	var frame: CGRect {
		get {
			switch type {
			case .shape:
				return shape.props.transform.rect
			case .picture:
				return picture.props.transform.rect
			case .connector:
				return connector.props.transform.rect
			case .groupshape:
				return groupshape.props.transform.rect
			case .graphicframe:
				return graphicframe.props.transform.rect
			case .paragraph:
				assertionFailure()
			case .combinedobject:
				return combinedobject.props.transform.rect
			}
			assertionFailure("invalid type")
			return CGRect.null
		}
		set {
			switch type {
			case .shape:
				shape.props.transform.rect = newValue
			case .picture:
				picture.props.transform.rect = newValue
			case .connector:
				connector.props.transform.rect = newValue
			case .groupshape:
				groupshape.props.transform.rect = newValue
			case .graphicframe:
				graphicframe.props.transform.rect = newValue
			case .paragraph:
				assertionFailure()
			case .combinedobject:
				combinedobject.props.transform.rect = newValue
			}
		}
	}

	var rotatedFrame: CGRect {
		return self.frame.rotateAtCenter(byDegree: CGFloat(self.props.transform.rotationAngle))
	}

	var props: Properties {
		get {
			switch type {
			case .shape:
				return shape.props
			case .picture:
				return picture.props
			case .groupshape:
				return groupshape.props
			case .connector:
				return connector.props
			case .paragraph:
				assertionFailure("paragraph don't have props")
				return shape.props
			case .graphicframe:
				return Properties.with {
					$0.transform = graphicframe.props.transform
				}
			case .combinedobject:
				return combinedobject.props
			}
		}
		set {
			switch type {
			case .shape:
				shape.props = newValue
			case .picture:
				picture.props = newValue
			case .groupshape:
				groupshape.props = newValue
			case .connector:
				connector.props = newValue
			case .paragraph:
				assertionFailure("paragraph don't have props")
			case .graphicframe:
				graphicframe.props.transform = newValue.transform // GraphicFrameProps has only transform as of now
			case .combinedobject:
				combinedobject.props = newValue
			}
		}
	}

	var vflip: Bool {
		get {
			switch type {
			case .shape:
				return shape.props.transform.flipv
			case .picture:
				return picture.props.transform.flipv
			case .groupshape:
				return groupshape.props.transform.flipv
			case .connector:
				return connector.props.transform.flipv
			case .paragraph:
				assertionFailure("paragraph not yet implemeted")
				return false
			case .graphicframe:
				assertionFailure("not supported for graphicframe")
				return false
			case .combinedobject:
				return combinedobject.props.transform.flipv
			}
		}
		set {
			switch type {
			case .shape:
				shape.props.transform.flipv = newValue
			case .picture:
				picture.props.transform.flipv = newValue
			case .groupshape:
				groupshape.props.transform.flipv = newValue
			case .connector:
				connector.props.transform.flipv = newValue
			case .paragraph:
				assertionFailure("paragraph not yet implemeted")
			case .graphicframe:
				assertionFailure("not supported for graphicframe")
			case .combinedobject:
				combinedobject.props.transform.flipv = newValue
			}
		}
	}

	var hflip: Bool {
		get {
			switch type {
			case .shape:
				return shape.props.transform.fliph
			case .picture:
				return picture.props.transform.fliph
			case .groupshape:
				return groupshape.props.transform.fliph
			case .connector:
				return connector.props.transform.fliph
			case .paragraph:
				assertionFailure("paragraph not yet implemeted")
				return false
			case .graphicframe:
				assertionFailure("not supported for graphicframe")
				return false
			case .combinedobject:
				return combinedobject.props.transform.fliph
			}
		}
		set {
			switch type {
			case .shape:
				shape.props.transform.fliph = newValue
			case .picture:
				picture.props.transform.fliph = newValue
			case .groupshape:
				groupshape.props.transform.fliph = newValue
			case .connector:
				connector.props.transform.fliph = newValue
			case .paragraph:
				assertionFailure("paragraph not yet implemeted")
			case .graphicframe:
				assertionFailure("not supported for graphicframe")
			case .combinedobject:
				combinedobject.props.transform.fliph = newValue
			}
		}
	}

	var rotation: Float {
		get {
			switch type {
			case .shape:
				return shape.props.transform.rotationAngle
			case .picture:
				return picture.props.transform.rotationAngle
			case .groupshape:
				return groupshape.props.transform.rotationAngle
			case .connector:
				return connector.props.transform.rotationAngle
			case .paragraph:
				assertionFailure("paragraph not yet implemeted")
			case .graphicframe:
				assertionFailure("not supported for graphicframe")
			case .combinedobject:
				return combinedobject.props.transform.rotationAngle
			}
			assertionFailure("contains check error")
			return 0
		}
		set {
			switch type {
			case .shape:
				shape.props.transform.rotationAngle = newValue
			case .picture:
				picture.props.transform.rotationAngle = newValue
			case .groupshape:
				groupshape.props.transform.rotationAngle = newValue
			case .connector:
				connector.props.transform.rotationAngle = newValue
			case .paragraph:
				assertionFailure("paragraph not yet implemeted")
			case .graphicframe:
				assertionFailure("not supported for graphicframe")
			case .combinedobject:
				combinedobject.props.transform.rotationAngle = newValue
			}
		}
	}

	var id: String {
		get {
			switch type {
			case .shape:
				return shape.nvOprops.nvDprops.id
			case .picture:
				return picture.nvOprops.nvDprops.id
			case .connector:
				return connector.nvOprops.nvDprops.id
			case .groupshape:
				return groupshape.nvOprops.nvDprops.id
			case .graphicframe:
				return graphicframe.nvOprops.nvDprops.id
			case .paragraph:
				assertionFailure("para don't have id")
				return ""
			case .combinedobject:
				return combinedobject.nvOprops.nvDprops.id
			}
		}
		set {
			switch type {
			case .shape:
				shape.nvOprops.nvDprops.id = newValue
			case .picture:
				picture.nvOprops.nvDprops.id = newValue
			case .connector:
				connector.nvOprops.nvDprops.id = newValue
			case .groupshape:
				groupshape.nvOprops.nvDprops.id = newValue
			case .graphicframe:
				graphicframe.nvOprops.nvDprops.id = newValue
			case .paragraph:
				assertionFailure("para don't have id")
			case .combinedobject:
				combinedobject.nvOprops.nvDprops.id = newValue
			}
		}
	}

	var isHidden: Bool {
		get {
			guard let nvdProps else {
				return false
			}
			return nvdProps.hasHidden && nvdProps.hidden
		}
		set {
			switch type {
			case .shape:
				shape.nvOprops.nvDprops.hidden = newValue
			case .picture:
				picture.nvOprops.nvDprops.hidden = newValue
			case .connector:
				connector.nvOprops.nvDprops.hidden = newValue
			case .groupshape:
				groupshape.nvOprops.nvDprops.hidden = newValue
			case .graphicframe:
				graphicframe.nvOprops.nvDprops.hidden = newValue
			case .paragraph:
				assertionFailure("para don't have hidden")
			case .combinedobject:
				combinedobject.nvOprops.nvDprops.hidden = newValue
			}
		}
	}

	var nvProps: NonVisualProps? {
		get {
			guard hasNvProps else {
				return nil
			}
			switch type {
			case .combinedobject:
				if combinedobject.hasNvOprops, combinedobject.nvOprops.hasNvProps {
					return combinedobject.nvOprops.nvProps
				}
			case .connector:
				if connector.hasNvOprops, connector.nvOprops.hasNvProps {
					return connector.nvOprops.nvProps
				}
			case .graphicframe:
				if graphicframe.hasNvOprops, graphicframe.nvOprops.hasNvProps {
					return graphicframe.nvOprops.nvProps
				}
			case .groupshape:
				if groupshape.hasNvOprops, groupshape.nvOprops.hasNvProps {
					return groupshape.nvOprops.nvProps
				}
			case .picture:
				if picture.hasNvOprops, picture.nvOprops.hasNvProps {
					return picture.nvOprops.nvProps
				}
			case .paragraph:
				assertionFailure("Paragraph doesn't have nvProps")
				return nil
			case .shape:
				if shape.hasNvOprops, shape.nvOprops.hasNvProps {
					return shape.nvOprops.nvProps
				}
			}
			return nil
		}
		set {
			if let newValue = newValue {
				switch type {
				case .combinedobject:
					combinedobject.nvOprops.nvProps = newValue
				case .connector:
					connector.nvOprops.nvProps = newValue
				case .graphicframe:
					graphicframe.nvOprops.nvProps = newValue
				case .groupshape:
					groupshape.nvOprops.nvProps = newValue
				case .picture:
					picture.nvOprops.nvProps = newValue
				case .paragraph:
					assertionFailure("Paragraph doesn't have nvProps")
				case .shape:
					shape.nvOprops.nvProps = newValue
				}
			}
		}
	}

	var nvdProps: NonVisualDrawingProps? {
		if !hasNvdProps {
			return nil
		}
		switch type {
		case .combinedobject:
			if combinedobject.hasNvOprops, combinedobject.nvOprops.hasNvDprops {
				return combinedobject.nvOprops.nvDprops
			}
		case .connector:
			if connector.hasNvOprops, connector.nvOprops.hasNvDprops {
				return connector.nvOprops.nvDprops
			}
		case .graphicframe:
			if graphicframe.hasNvOprops, graphicframe.nvOprops.hasNvDprops {
				return graphicframe.nvOprops.nvDprops
			}
		case .groupshape:
			if groupshape.hasNvOprops, groupshape.nvOprops.hasNvDprops {
				return groupshape.nvOprops.nvDprops
			}
		case .picture:
			if picture.hasNvOprops, picture.nvOprops.hasNvDprops {
				return picture.nvOprops.nvDprops
			}
		case .paragraph:
			assertionFailure("Paragraph doesn't have nvProps")
			return nil
		case .shape:
			if shape.hasNvOprops, shape.nvOprops.hasNvDprops {
				return shape.nvOprops.nvDprops
			}
		}
		return nil
	}
}

private extension ShapeObject {
	var hasNvProps: Bool {
		switch type {
		case .combinedobject:
			return combinedobject.hasNvOprops && combinedobject.nvOprops.hasNvProps
		case .connector:
			return connector.hasNvOprops && connector.nvOprops.hasNvProps
		case .graphicframe:
			return graphicframe.hasNvOprops && graphicframe.nvOprops.hasNvProps
		case .groupshape:
			return groupshape.hasNvOprops && groupshape.nvOprops.hasNvProps
		case .picture:
			return picture.hasNvOprops && picture.nvOprops.hasNvProps
		case .paragraph:
			assertionFailure("Paragraph doesn't have nvProps")
			return false
		case .shape:
			return shape.hasNvOprops && shape.nvOprops.hasNvProps
		}
	}

	var hasNvdProps: Bool {
		switch type {
		case .combinedobject:
			return combinedobject.hasNvOprops && combinedobject.nvOprops.hasNvDprops
		case .connector:
			return connector.hasNvOprops && connector.nvOprops.hasNvDprops
		case .graphicframe:
			return graphicframe.hasNvOprops && graphicframe.nvOprops.hasNvDprops
		case .groupshape:
			return groupshape.hasNvOprops && groupshape.nvOprops.hasNvDprops
		case .picture:
			return picture.hasNvOprops && picture.nvOprops.hasNvDprops
		case .paragraph:
			assertionFailure("Paragraph doesn't have nvProps")
			return false
		case .shape:
			return shape.hasNvOprops && shape.nvOprops.hasNvDprops
		}
	}
}
