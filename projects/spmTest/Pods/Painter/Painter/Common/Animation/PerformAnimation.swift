//
//  PerformAnimation.swift
//  Painter
//
//  Created by Abhijitkumar A on 27/11/18.
//  Copyright © 2018 Zoho Corporation Pvt. Ltd. All rights reserved.
//

#if !os(watchOS)
import Proto
import QuartzCore

public enum RotationMode {
	case x
	case y
	case z
}

public protocol CoreAnimationProtocol: AnyObject {
	func animationStarted(forAnimID id: String)
	func animationEnded(forAnimID id: String, didComplete flag: Bool)
}

public class PerformAnimation: NSObject, CAAnimationDelegate {
	public weak var delegate: CoreAnimationProtocol?
	var coreAnimationData: CoreAnimation
	public var groupAnimation = [CAAnimation]()
	private var animationLayer: CALayer
	public var rotation = RotationMode.z
	public var stayObjectAlong = false

	public init(WithLayer layer: CALayer, AndCoreAnimationData data: CoreAnimation, shouldStayObjectAlong: Bool = false) {
		self.coreAnimationData = data
		self.animationLayer = layer
		self.stayObjectAlong = shouldStayObjectAlong
	}

	func prepareAnimation() {
		if self.coreAnimationData.custom.atStart.hasTransform || self.coreAnimationData.custom.byEnd.hasTransform {
			if self.coreAnimationData.custom.atStart.transform.hasPos || self.coreAnimationData.custom.byEnd.transform.hasPos {
				self.createPositionAnimation()
			}
			if self.coreAnimationData.custom.atStart.transform.hasDim {
				self.createScaleAnimation()
			}
			if self.hasRotationAnim(self.coreAnimationData.custom) {
				self.createRotateAnimation()
			}
		}
		if self.coreAnimationData.custom.atStart.hasFill || self.coreAnimationData.custom.byEnd.hasFill {
			if self.coreAnimationData.custom.atStart.fill.solid.hasColor || self.coreAnimationData.custom.byEnd.fill.solid.hasColor {
				self.createColorAnimation()
			}
			if self.coreAnimationData.custom.atStart.fill.hasAlpha || self.coreAnimationData.custom.byEnd.fill.hasAlpha {
				self.createOpacityAnimation()
			}
		}

		if self.coreAnimationData.custom.atStart.hasPath {
			createPathAnimation()
		}
		if !self.coreAnimationData.custom.pathToFollow.isEmpty {
			createPathToFollowAnimation()
		}
	}

	public func start() {
		self.prepareAnimation()
		if !self.groupAnimation.isEmpty {
			self.startPerformingAnimations()
		}
	}

	func stop() {
		self.animationLayer.removeAnimation(forKey: self.coreAnimationData.id)
	}

	private func startPerformingAnimations() {
		let animation = CAAnimationGroup()
		animation.animations = self.groupAnimation
		animation.beginTime = CACurrentMediaTime() + CFTimeInterval(self.coreAnimationData.delay)
		animation.duration = CFTimeInterval(self.coreAnimationData.duration)
		animation.timingFunction = PerformAnimation.getTimingFunctionForEasing(animationEasing: self.coreAnimationData.easing)
		animation.fillMode = .both
		animation.delegate = self
		self.animationLayer.add(animation, forKey: self.coreAnimationData.id)
	}

	private func createPositionAnimation() {
		let positionAnimation = CABasicAnimation()
		positionAnimation.keyPath = "position"
		if self.coreAnimationData.custom.hasAtStart {
			let pos = self.coreAnimationData.custom.atStart.transform.pos
			if pos.hasTop, pos.hasLeft {
				positionAnimation.fromValue = CGPoint(
					x: CGFloat(pos.left),
					y: CGFloat(pos.top))
			} else if pos.hasLeft {
				positionAnimation.keyPath = "position.x"
				positionAnimation.fromValue = CGFloat(pos.left)
			} else if pos.hasTop {
				positionAnimation.keyPath = "position.y"
				positionAnimation.fromValue = CGFloat(pos.top)
			}
		}
		if self.coreAnimationData.custom.hasByEnd {
			let pos = self.coreAnimationData.custom.byEnd.transform.pos
			if pos.hasTop, pos.hasLeft {
				positionAnimation.toValue = CGPoint(
					x: CGFloat(pos.left),
					y: CGFloat(pos.top))
			} else if pos.hasLeft {
				positionAnimation.keyPath = "position.x"
				positionAnimation.toValue = CGFloat(pos.left)
			} else if pos.hasTop {
				positionAnimation.keyPath = "position.y"
				positionAnimation.toValue = CGFloat(pos.top)
			}
		}
		self.groupAnimation.append(positionAnimation)
	}

	private func createScaleAnimation() {
		let scaleAnimation = CABasicAnimation()
		scaleAnimation.keyPath = "bounds"
		scaleAnimation.fromValue = CGRect(
			x: 0,
			y: 0,
			width: CGFloat(self.coreAnimationData.custom.atStart.transform.dim.width),
			height: CGFloat(self.coreAnimationData.custom.atStart.transform.dim.height))
		scaleAnimation.toValue = CGRect(
			x: 0,
			y: 0,
			width: CGFloat(self.coreAnimationData.custom.byEnd.transform.dim.width),
			height: CGFloat(self.coreAnimationData.custom.byEnd.transform.dim.height))
		self.groupAnimation.append(scaleAnimation)
	}

	private func createRotateAnimation() {
		let rotateAnimation = CABasicAnimation()
		rotateAnimation.keyPath = self.getRotationKeyPath()
		if !self.coreAnimationData.custom.hasAtStart, self.coreAnimationData.custom.hasByEnd {
			let end = self.coreAnimationData.custom.byEnd
			if end.transform.hasRotate {
				let rotate = Double(end.transform.rotate)
				rotateAnimation.byValue = (.pi / 180.0) * rotate
			} else if end.transform.hasRotAngle {
				let rotate = end.transform.rotAngle
				rotateAnimation.byValue = (.pi / 180.0) * rotate
			}
		} else {
			if self.coreAnimationData.custom.hasAtStart {
				let start = self.coreAnimationData.custom.atStart
				if start.transform.hasRotate {
					rotateAnimation.fromValue = (.pi / 180.0) * Double(start.transform.rotate)
				} else if start.transform.hasRotAngle {
					rotateAnimation.fromValue = (.pi / 180.0) * Double(start.transform.rotationAngle)
				}
			}
			if self.coreAnimationData.custom.hasByEnd {
				let end = self.coreAnimationData.custom.byEnd
				if end.transform.hasRotate {
					let rotate = Double(end.transform.rotate)
					rotateAnimation.toValue = (.pi / 180.0) * rotate
				} else if end.transform.hasRotAngle {
					let rotate = end.transform.rotAngle
					rotateAnimation.toValue = (.pi / 180.0) * rotate
				}
			}
		}
		self.groupAnimation.append(rotateAnimation)
	}

	private func getRotationKeyPath() -> String {
		switch self.rotation {
		case .x:
			return "transform.rotation.x"
		case .y:
			return "transform.rotation.y"
		case .z:
			return "transform.rotation.z"
		}
	}

	private func hasRotationAnim(_ custom: CustomAnimation) -> Bool {
		if custom.atStart.transform.hasRotAngle {
			return true
		}
		if custom.atStart.transform.hasRotate {
			return true
		}
		if custom.byEnd.transform.hasRotAngle {
			return true
		}
		if custom.byEnd.transform.hasRotate {
			return true
		}
		return false
	}

	private func createColorAnimation() {
		let colorAnimation = CABasicAnimation()
		if self.animationLayer is CAShapeLayer {
			colorAnimation.keyPath = "fillColor"
		} else {
			colorAnimation.keyPath = "backgroundColor"
		}
		if self.coreAnimationData.custom.hasAtStart {
			colorAnimation.fromValue = self.coreAnimationData.custom.atStart.fill.solid.color.cgColor
		}
		if self.coreAnimationData.custom.hasByEnd {
			colorAnimation.toValue = self.coreAnimationData.custom.byEnd.fill.solid.color.cgColor
		}
		self.groupAnimation.append(colorAnimation)
	}

	private func createOpacityAnimation() {
		let opacityAnimation = CABasicAnimation()
		opacityAnimation.keyPath = "opacity"
		if self.coreAnimationData.custom.hasAtStart {
			opacityAnimation.fromValue = 1 - self.coreAnimationData.custom.atStart.fill.alpha
		}
		if self.coreAnimationData.custom.hasByEnd {
			opacityAnimation.toValue = 1 - self.coreAnimationData.custom.byEnd.fill.alpha
		}
		self.groupAnimation.append(opacityAnimation)
	}

	public func animationDidStart(_ anim: CAAnimation) {
		let center = self.animationLayer.frame.center
		self.animationLayer.anchorPoint = CGPoint(0.5, 0.5)
		self.animationLayer.position = center
		self.delegate?.animationStarted(forAnimID: self.coreAnimationData.id)
	}

	public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
		_ = self.animationLayer.presentation()
		self.delegate?.animationEnded(forAnimID: self.coreAnimationData.id, didComplete: flag)
	}

	deinit {
		Debugger.deInit(self.classForCoder)
	}
}

extension PerformAnimation {
	public static func getTimingFunctionForEasing(animationEasing: AnimationEasing) -> CAMediaTimingFunction {
		if animationEasing.base == .none {
			return CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
		} else if animationEasing.base == .easeIn {
			return CAMediaTimingFunction(
				controlPoints: 0.5, 0, 0.88, 0.77)
		} else if animationEasing.base == .easeOut {
			return CAMediaTimingFunction(
				controlPoints: 0.12, 0.23, 0.5, 1)
		} else {
			return CAMediaTimingFunction(
				controlPoints: 0.44, 0, 0.56, 1)
		}
	}

	static func getTimingFunctionForEaseIn(curve: AnimationEasing.EasingCurve) -> CAMediaTimingFunction {
		switch curve {
		case .sine:
			return CAMediaTimingFunction(controlPoints: 0.47, 0, 0.745, 0.715)
		case .cubic:
			return CAMediaTimingFunction(controlPoints: 0.55, 0.055, 0.675, 0.19)
		case .quintic:
			return CAMediaTimingFunction(controlPoints: 0.755, 0.05, 0.855, 0.06)
		case .circle:
			return CAMediaTimingFunction(controlPoints: 0.6, 0.04, 0.98, 0.335)
		case .quadratic:
			return CAMediaTimingFunction(controlPoints: 0.55, 0.085, 0.68, 0.53)
		case .quartic:
			return CAMediaTimingFunction(controlPoints: 0.895, 0.03, 0.685, 0.22)
		case .exponential:
			return CAMediaTimingFunction(controlPoints: 0.95, 0.05, 0.795, 0.035)
		case .back:
			return CAMediaTimingFunction(controlPoints: 0.6, -0.28, 0.735, 0.045)
		default:
			return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
		}
	}

	static func getTimingFunctionForEaseOut(curve: AnimationEasing.EasingCurve) -> CAMediaTimingFunction {
		switch curve {
		case .sine:
			return CAMediaTimingFunction(controlPoints: 0.39, 0.575, 0.565, 1)
		case .cubic:
			return CAMediaTimingFunction(controlPoints: 0.215, 0.61, 0.355, 1)
		case .quintic:
			return CAMediaTimingFunction(controlPoints: 0.23, 1, 0.32, 1)
		case .circle:
			return CAMediaTimingFunction(controlPoints: 0.075, 0.82, 0.165, 1)
		case .quadratic:
			return CAMediaTimingFunction(controlPoints: 0.25, 0.46, 0.45, 0.94)
		case .quartic:
			return CAMediaTimingFunction(controlPoints: 0.165, 0.84, 0.44, 1)
		case .exponential:
			return CAMediaTimingFunction(controlPoints: 0.19, 1, 0.22, 1)
		case .back:
			return CAMediaTimingFunction(controlPoints: 0.175, 0.885, 0.32, 1.275)
		default:
			return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
		}
	}

	static func getTimingFunctionForEaseInOut(curve: AnimationEasing.EasingCurve) -> CAMediaTimingFunction {
		switch curve {
		case .sine:
			return CAMediaTimingFunction(controlPoints: 0.445, 0.05, 0.55, 0.95)
		case .cubic:
			return CAMediaTimingFunction(controlPoints: 0.645, 0.045, 0.355, 1)
		case .quintic:
			return CAMediaTimingFunction(controlPoints: 0.86, 0, 0.07, 1)
		case .circle:
			return CAMediaTimingFunction(controlPoints: 0.785, 0.135, 0.15, 0.86)
		case .quadratic:
			return CAMediaTimingFunction(controlPoints: 0.455, 0.03, 0.515, 0.955)
		case .quartic:
			return CAMediaTimingFunction(controlPoints: 0.77, 0, 0.175, 1)
		case .exponential:
			return CAMediaTimingFunction(controlPoints: 1, 0, 0, 1)
		case .back:
			return CAMediaTimingFunction(controlPoints: 0.68, -0.55, 0.265, 1.55)
		default:
			return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
		}
	}
}
#endif
